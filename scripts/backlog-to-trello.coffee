#
# Description:
#   Backlog to Trello
#
# Dependencies:
#   "node-trello": "^1.1.1"
#
# Configuration:
#    HUBOT_TRELLO_KEY
#    HUBOT_TRELLO_TOKEN
#    HUBOT_TRELLO_POST_ALL
#    HUBOT_TRELLO_POST_MATSUE
#    HUBOT_TRELLO_POST_MORITA
#    HUBOT_TRELLO_POST_SEINO
#    HUBOT_TRELLO_POST_YAMAGUCHI
#    HUBOT_TRELLO_POST_NOJI
#    HUBOT_TRELLO_POST_TAKAYAMA
#    BACKLOG_URL
#
#    MATSUE
#    MORITA
#    SEINO
#    YAMAGUCHI
#    NOJI
#    TAKAYAMA
#    ※heroku 環境設定
#
# Commands:
#   
#

backlogUrl = process.env.BACKLOG_URL

module.exports = (robot) ->
  Trello = require("node-trello")
  t = new Trello(process.env.HUBOT_TRELLO_KEY, process.env.HUBOT_TRELLO_TOKEN)

  robot.router.post "/trello/:room", (req, res) ->
    room = req.params.room
    body = req.body

    try
      switch body.type
          when 1
              label = '課題の追加'
          else
              # 課題関連以外はスルー
              return

      list_id = ''
      user_id = ''
      assign_user = ''
      if body.content.assignee.name?
          assign_user = body.content.assignee.name
      else
          assign_user = 'ENRISE'

      switch assign_user
          when process.env.MATSUE
              list_id = process.env.HUBOT_TRELLO_POST_MATSUE
              user_id = '5821cf813367548d6257adf2'
          when process.env.MORITA
              list_id = process.env.HUBOT_TRELLO_POST_MORITA
              user_id = '582065b115b6950e48fa6931'
          when process.env.SEINO
              list_id = process.env.HUBOT_TRELLO_POST_SEINO
              user_id = '5cf9b5fabce5b92a62c4d33f'
          when process.env.YAMAGUCHI
              list_id = process.env.HUBOT_TRELLO_POST_YAMAGUCHI
              user_id = '5cf9b57075f54c533cc781a8'
          when process.env.NOJI
              list_id = process.env.HUBOT_TRELLO_POST_NOJI
              user_id = '5cf9bfa126aec27f6b5bba8d'
          when process.env.TAKAYAMA
              list_id = process.env.HUBOT_TRELLO_POST_TAKAYAMA
              user_id = '5851f3feb339a2ac50dafff4'
          when 'ENRISE'
              list_id = process.env.HUBOT_TRELLO_POST_ALL
              user_id = '5821cf813367548d6257adf2'

      # 投稿メッセージを整形
      url = "#{backlogUrl}view/#{body.project.projectKey}-#{body.content.key_id}"

      title = "[#{body.project.projectKey}-#{body.content.key_id}] "
      title += "#{body.content.summary}"

      description = "#{url}\n"
      description += "登録者：#{body.createdUser.name}\n\n"
      description += "#{body.content.description}"

      due = ''
      if body.content.dueDate?
          due = body.content.dueDate

      t.post "/1/cards/", {
        name: title
        desc: description
        idList: list_id
        idMembers: user_id
        due: due
      }, (err, data) ->
        if (err)
          console.log err
          return

#     # カードを追加したら Slack に投稿したい場合はここを利用
#     if title?
#         robot.messageRoom room, title
#         res.end "OK"
#     else
#         robot.messageRoom room, "Backlog integration error."
#         res.end "Error"

    catch error
      robot.send
      res.end "Error"