import time
from slackclient import SlackClient

token = "xoxp-9476792739-32448196322-51493404306-7499d7027a"# found at https://api.slack.com/web#authentication
sc = SlackClient(token)
print sc.api_call(
            "chat.postMessage", channel="#gridlibrary", text="test",
                username='bot', icon_emoji=':robot_face:'
                )
