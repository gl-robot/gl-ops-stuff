import time
import subprocess

from slackclient import SlackClient

def get_new_users():
  return subprocess.check_output('sudo -u postgres psql -c "SELECT id, full_name, create_date FROM  users WHERE create_date > current_timestamp - interval \'1 hour\' " \
                                  | awk \'{print $3, $4}\'                                                                                                              \
                                  | sed \'1d;2d;$d\'                                                                                                                    \
                                  | sed \'$d\''                                                                                                                         \
                                  , shell=True)

def post_stat(channel_, text_, sc):
  sc.api_call(
      "chat.postMessage", channel=channel_, text=text_,
      username='bot', icon_emoji=':robot_face:')

if __name__ == "__main__":

  token = "secret"# found at https://api.slack.com/web#authentication
  sc = SlackClient(token)

  msg = "New users in last hour: \n"
  new_users = get_new_users()

  if new_users == "":
    print "No new users"
  else:
    print new_users
    print sc.api_call(
      "chat.postMessage", channel="#gridlibrary", text=msg + new_users,
      username='Grid Library Robot', icon_emoji=':robot_face:')

