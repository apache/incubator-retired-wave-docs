.. Licensed to the Apache Software Foundation (ASF) under one
   or more contributor license agreements.  See the NOTICE file
   distributed with this work for additional information
   regarding copyright ownership.  The ASF licenses this file
   to you under the Apache License, Version 2.0 (the
   "License"); you may not use this file except in compliance
   with the License.  You may obtain a copy of the License at

..   http://www.apache.org/licenses/LICENSE-2.0

.. Unless required by applicable law or agreed to in writing,
   software distributed under the License is distributed on an
   "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
   KIND, either express or implied.  See the License for the
   specific language governing permissions and limitations
   under the License.

Authentication
==============

Applications must authenticate on behalf of the user before they can retrieve
or modify any Wave data. This authentication is done via OAuth, There are
multiple steps involved in authenticating a user to your application via OAuth,
and these steps are documented in the OAuth for Web Applications documentation.

The process is made easier by methods in the client library, and this document
shows how to use those methods.

Contents

.. toctree::

Authenticating in Python
------------------------

Here, we'll demonstrate the 5 steps of the OAuth authorization process using
the Python client library.

First, you should create a WaveService object, as you will call all the
required methods on that object:


from waveapi import waveservice

service = waveservice.WaveService()
Next, your application must get an unauthorized request token from Google's
authorization server. Along with the request, you should specify a callback
that Google will return to with the new token information, and the callback
should be wired to a handler in your application:


callback_url = "%s/oauth/verify" % self.request.host_url
request_token = service.fetch_request_token(callback=callback_url)

Now, you should store the request token information so that you can re-create
it after the next step. In this example, we use the App Engine datastore to
create an OAuthRequestToken entity, but you could also use memcache or other
similar storage mechanisms:


# declared earlier
class OAuthRequestToken(db.Model):
  token_key = db.StringProperty(required=True)
  token_secret = db.StringProperty()
  created = db.DateTimeProperty(auto_now_add=True)
  token_ser = db.TextProperty()

db_token = OAuthRequestToken(token_key = request_token.key, token_ser =
request_token.to_string())
db_token.put()
Next, you must direct the user to an authorization URL for the token:


auth_url = self._service.generate_authorization_url()
self.redirect(auth_url)
After the user has returned to your application, at the handler specified by
the callback URL, you need to match that user with the token you stored
earlier, and upgrade that token to an access token:


token_key = self.request.get('oauth_token')
db_token = OAuthRequestToken.all().filter(
      'token_key =', token_key).fetch(1)[0]
token = oauth.OAuthToken.from_string(db_token.token_ser)

access_token = self._service.upgrade_to_access_token(request_token=token,
                                                     verifier=verifier)

Now, similar to before, you should store this access token so that you can use
it for the user when they return to your app in the future, so they don't have
to authenticate each time. In this example, we do that by generating a random
session ID for the user, saving that ID in a cookie, and storing the token with
that ID in the datastore:


# declared earlier
class OAuthAccessToken(db.Model):
  token_ser = db.TextProperty(required=True)
  token_key = db.StringProperty(required=True)
  token_secret = db.StringProperty(required=True)
  created = db.DateTimeProperty(auto_now_add=True)
  session = db.StringProperty(required=True)

session_id = str(uuid.uuid1())
db_token = OAuthAccessToken(session=session_id, token_key = access_token.key,
        token_secret=access_token.secret, token_ser=access_token.to_string())
db_token.put()

self.response.headers.add_header('Set-Cookie', '%s=%s; path=/;' %
                                (WaveOAuthHandler.COOKIE, session_id))

Now that you have an access token associated with the user, you can use that
token each time you want to request or modify data on behalf of the user. For
example, here's how you can find the access token based on the user cookie, and
then tell the WaveService object about the token:


session_id = self.request.cookies.get(WaveOAuthHandler.COOKIE)
db_query = OAuthAccessToken.all().filter('session =', session_id)
db_token = db_query.get()
service.set_access_token(db_token.token_ser)

Now you can use the WaveService object to issue all requests, because it has
the token information and knows how to sign each of the requests properly. Read
the Operations guide for examples. For an example of a sample that uses this
OAuth flow, see the Inbox Checker.

Authenticating in Java
----------------------

The Java client library does not have built-in methods for each step of the
OAuth process like the Python library, but it can be used in conjunction with
existing OAuth libraries to authenticate a user.

The additional libraries required are:

* OAuth library -
  http://code.google.com/p/oauth/source/browse/code/maven/net/oauth/core
* Apache's HTTP Client library -
  http://hc.apache.org/httpcomponents-client/download.html
* OAuth HTTP Client Library -
  http://code.google.com/p/oauth/source/browse/code/maven/net/oauth/core#core/oauth-httpclient4

The first step is to create a Filter class that handles OAuth authorization, by
checking if the user has authenticated yet and stepping them through the
process if not. The filter will make sure that an access token will exist by
the time the request reaches the servlet.

The empty OAuthFilter class looks like this:


import java.io.*;

import javax.servlet.*;
import javax.servlet.http.*;

import net.oauth.*;
import net.oauth.client.*;
import net.oauth.client.httpclient4.*;

public class OAuthFilter implements Filter {
  @Override
  public void doFilter(ServletRequest req, ServletResponse resp,
      FilterChain filterChain) throws IOException, ServletException {
  }

  @Override
  public void init(FilterConfig filterConfig) throws ServletException {
  }

  @Override
  public void destroy() {
  }
}

Now, we need to define some constants used in the process - the key and secret
for the application (more info here), the URL endpoints for creating and
authorizing tokens, names of cookies storing credentials, and an OAuthClient
instance for use throughout the process.


  // Consumer key and secret. For real app, need to register a real one.
  private static final String CONSUMER_KEY = "anonymous";
  private static final String CONSUMER_SECRET = "anonymous";

  // OAuth handlers.
  private static final String REQUEST_URL =
      "https://www.google.com/accounts/OAuthGetRequestToken?" +
      "scope=http%3A%2F%2Fwave.googleusercontent.com%2Fapi%2Frpc";
  private static final String AUTHORIZE_URL =
      "https://www.google.com/accounts/OAuthAuthorizeToken";
  private static final String ACCESS_URL =
      "https://www.google.com/accounts/OAuthGetAccessToken";
  private static final String CALLBACK_URL = "http://localhost:8888/dataapi";

  // Cookies that store OAuth credentials.
  private static final String REQUEST_TOKEN = "requesttoken";
  private static final String ACCESS_TOKEN = "accesstoken";
  private static final String TOKEN_SECRET = "tokensecret";

  // OAuth client.
  public static final OAuthClient OAUTH_CLIENT = new OAuthClient(
  new HttpClient4());

Next, we add two helper methods, createAccessor for populating an OAuthAccessor
object with values stored in cookies, and getCookie for retrieving cookie
values.


public static OAuthAccessor createAccessor(HttpServletRequest req) {
  OAuthServiceProvider provider = new OAuthServiceProvider(REQUEST_URL,
      AUTHORIZE_URL, ACCESS_URL);
  OAuthConsumer consumer = new OAuthConsumer(CALLBACK_URL, CONSUMER_KEY,
      CONSUMER_SECRET, provider);
  OAuthAccessor accessor = new OAuthAccessor(consumer);
  accessor.requestToken = getCookie(req, REQUEST_TOKEN);
  accessor.accessToken = getCookie(req, ACCESS_TOKEN);
  accessor.tokenSecret = getCookie(req, TOKEN_SECRET);
  return accessor;
}

private static String getCookie(HttpServletRequest req, String cookieName) {
  Cookie[] cookies = req.getCookies();
  if (cookies != null) {
    for (Cookie cookie : cookies) {
      if (cookieName.equals(cookie.getName())) {
        return cookie.getValue();
      }
    }
  }
  return null;
}

Now, we can add functionality to the doFilter method for going through each
step of the process.First, we check if there is a request token associated with
the current request, and if not, we do the first two steps of the OAuth
dance - getting a request token, and sending the user to the authorization URL.


  HttpServletResponse response = (HttpServletResponse) resp;
  OAuthAccessor accessor = createAccessor((HttpServletRequest) req);
  if (accessor.requestToken == null) {
    OAUTH_CLIENT.getRequestToken(accessor);
    response.addCookie(new Cookie(REQUEST_TOKEN, accessor.requestToken));
    response.addCookie(new Cookie(TOKEN_SECRET, accessor.tokenSecret));

    String url = accessor.consumer.serviceProvider.userAuthorizationURL +
        "?oauth_token=" + accessor.requestToken +
        "&oauth_callback=" + CALLBACK_URL +
        "&hd=default";

    response.sendRedirect(url);
    return;
  }

Now, when the user returns from the authorization URL, there will be a request
token stored but no access token. In that case, we request an access token and
store it in the cookies.


  if (accessor.accessToken == null) {
    OAuthMessage msg = OAUTH_CLIENT.getAccessToken(accessor, "GET",
      OAuth.newList("oauth_token", accessor.requestToken));
    accessor.accessToken = msg.getParameter("oauth_token");
    accessor.tokenSecret = msg.getParameter("oauth_token_secret");
    response.addCookie(new Cookie(ACCESS_TOKEN, accessor.accessToken));
    response.addCookie(new Cookie(TOKEN_SECRET, accessor.tokenSecret));
  }

After the user has an access token, both that and the request token will be
non-null, and we can send the request on to the actual servlet.


  filterChain.doFilter(req, resp);

In our actual servlet, we create a WaveService instance, set the access token
according to the cookies, and pass that into the service.


  public void doGet(HttpServletRequest req, HttpServletResponse resp)
      throws IOException {
    OAuthAccessor accessor = OAuthFilter.createAccessor(req);
    WaveService waveService = new WaveService();
    waveService.setupOAuth(accessor, WaveService.RPC_URL);
  }

Now you can use the WaveService object to issue all requests, because it has
the token information and knows how to sign each of the requests properly. Read
the Operations guide for examples. For an example of a sample that uses this
OAuth flow, see Splash.