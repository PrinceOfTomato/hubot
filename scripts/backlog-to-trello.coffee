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
#
#    MATSUE
#    MORITA
#    SEINO
#    YANAGUCHI
#    NOJI
#    TAKAYAMA
#    ※heroku 環境設定
#
# Commands:
#   
#

backlogUrl = 'https://ryota-noji.backlog.jp/'

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
      switch body.content.assignee.name
          when MATSUE
              list_id = HUBOT_TRELLO_POST_MATSUE
              user_id = 'ryotanoji1'
          when MORITA
              list_id = HUBOT_TRELLO_POST_MORITA
              user_id = 'ryotanoji1'
          when SEINO
              list_id = HUBOT_TRELLO_POST_SEINO
              user_id = 'ryotanoji1'
          when YANAGUCHI
              list_id = HUBOT_TRELLO_POST_YAMAGUCHI
              user_id = 'ryotanoji1'
          when NOJI
              list_id = HUBOT_TRELLO_POST_NOJI
              user_id = 'ryotanoji1'
          when TAKAYAMA
              list_id = HUBOT_TRELLO_POST_TAKAYAMA
              user_id = 'ryotanoji1'
          else
              list_id = HUBOT_TRELLO_POST_ALL
              user_id = 'ryotanoji1'

      # 投稿メッセージを整形
      url = "#{backlogUrl}view/#{body.project.projectKey}-#{body.content.key_id}"

      title = "[#{body.project.projectKey}-#{body.content.key_id}] "
      title += "#{body.content.summary}"

      description = "#{url}\n"
      description += "登録者：#{body.createdUser.name}\n\n"
      description += "#{body.content.description}"

      t.post "/1/cards/", {
        name: title
        desc: description
        idList: list_id
        idMembers: user_id
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