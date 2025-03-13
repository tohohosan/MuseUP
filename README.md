# MuseUP (みゅーじあっぷ)
**https://museup.jp/**
![image](https://github.com/user-attachments/assets/66b3c29b-6839-4643-8de6-4091fd284998)

# 🌟サービス概要
~ ミュージアムをもっと知る、もっと楽しむ。~

近くのミュージアム（博物館・美術館等）を検索したり、おススメしたいミュージアムを投稿したりして、もっとミュージアムを知る・楽しむことができるサービスです。  
ユーザーは、他のユーザーが投稿したミュージアムの詳細を閲覧したり、地域やカテゴリ、現在地から条件に該当するミュージアムを探すことができます。そして、ミュージアム好きなユーザーは、自分がおススメしたいミュージアムを投稿したり、ミュージアムのレビューを投稿することが出来ます。加えて、ミュージアムをリストに登録して管理したり、ミュージアムに対してプライベートなメモを記録することができます。  
  
# 📖開発の背景
私は大学で歴史学を専攻しており、博物館の学芸員資格も取得しました。  
そんな自分にとって博物館や美術館は身近なものでしたが、あまり行ったことがない人も多いことを知り、もっと身近に感じてほしいと考えました。ミュージアムの検索機能によって、「自分の近くにこんなミュージアムがあるんだ！」と感じてもらいたいと思っています。  
また、自分のようなミュージアム好きのユーザーにとっても、まだ知らないミュージアムを知る機会となり、さらにリストやメモ機能によって、ミュージアムをもっと楽しむ一助になればと考えております。


# 💻主要な機能
| ユーザー登録、ログイン機能 |
|:-----------|
|[![Image from Gyazo](https://i.gyazo.com/bfe842646f42352ddbf27202b5e47f90.gif)](https://gyazo.com/bfe842646f42352ddbf27202b5e47f90)     | 
| メールアドレスとパスワードを設定して、ユーザー登録ができます。また、ログインのハードルを下げるため、Google アカウントや X のアカウントでもログインが可能です。     |

| ミュージアム検索 |
|:-----------|
| [![Image from Gyazo](https://i.gyazo.com/598b6b3c1acc5797c758634e60bd5d18.gif)](https://gyazo.com/598b6b3c1acc5797c758634e60bd5d18)     | 
| ミュージアム名・都道府県、カテゴリから AND 検索ができます。また、ユーザーの現在の位置情報から最も近いミュージアムも検索できます。     |

| ミュージアム詳細 |
|:-----------|
| [![Image from Gyazo](https://i.gyazo.com/89e7a77666b8f4cf8eec023030eb4962.gif)](https://gyazo.com/89e7a77666b8f4cf8eec023030eb4962)       | 
| ミュージアム一覧のピンをクリックすると詳細ページを閲覧できます。詳細情報、レビュー、リスト、メモのタブの切り替えができます。     |

| ミュージアム投稿（ログイン限定） |
|:-----------|
| [![Image from Gyazo](https://i.gyazo.com/ee0bb62f002032b06385c9226c520ac5.gif)](https://gyazo.com/ee0bb62f002032b06385c9226c520ac5)       | 
| ユーザーはミュージアムを投稿できます。ミュージアム名を途中まで入力すると、オートコンプリート機能で候補がサジェストされます。候補から選択すると住所が自動的に入力されます。      |

| レビュー機能（ログイン限定） |
|:-----------|
| [![Image from Gyazo](https://i.gyazo.com/f24319d00d5ff7a31f1e6cb7f09618ba.gif)](https://gyazo.com/f24319d00d5ff7a31f1e6cb7f09618ba)      | 
| ユーザーはミュージアムのレビューを投稿できます。レビューの内容と 5 段階の評価を記録できます。     |

| リスト機能（ログイン限定） |
|:-----------|
| [![Image from Gyazo](https://i.gyazo.com/ade8e43cf7fc70db30527666c1eefd03.gif)](https://gyazo.com/ade8e43cf7fc70db30527666c1eefd03)        | 
| ユーザーはミュージアムをリストに登録できます。デフォルトで「行きたい」と「行った」リストが用意されています。それに加えて、ユーザーは任意のリストを新規作成できます。      |

| メモ機能（ログイン限定） |
|:-----------|
| [![Image from Gyazo](https://i.gyazo.com/eaf3373f9cb9737ce8e0e1d59521a68e.gif)](https://gyazo.com/eaf3373f9cb9737ce8e0e1d59521a68e)       | 
| ユーザーはミュージアムに対するプライベートなメモを記録することができます。      |
  
# 🔧技術構成
## ER 図
[Lucidchart](https://lucid.app/lucidchart/2716b1de-cf07-4dcc-a26d-5aad6ebfddd3/edit?viewport_loc=-2148%2C-109%2C4039%2C1876%2C0_0&invitationId=inv_d7b8efe5-7b2a-43b8-8af5-8c2bc4022823)
![空白の図 (4)](https://github.com/user-attachments/assets/7f662130-97ce-44cf-aa72-f345df48d97a)


## 画面遷移図
[Figma](https://www.figma.com/design/AKh4o0wpuAARXc1Ha80qgS/%E7%84%A1%E9%A1%8C?node-id=0-1&t=hWs0E2hdRpTOl0hV-1)

## 使用技術
| カテゴリ | 技術 | 
|:-----------|------------:|
| フロントエンド     | HTML / CSS (Tailwind CSS + daisyUI) / Javascript     | 
| サーバーサイド       | Ruby 3.3.6 / Ruby on Rails 7.2.2.1        | 
| データベース         | PostgreSQL          | 
| インフラ       | Render.com / Amazon S3       | 
| Web API    | Maps Javascript API / Geocoding API / Places API     | 
| その他 gem       | devise / carrierwave / mini_magick / ransack / kaminari / rails_admin / omniauth       | 
