# README

# 76a DB設計

## usersテーブル
|Column|Type|Options|
|------|----|-------|
|family_name|string|null: false|
|first_name|string|null: false|
|family_name_kana|string|null: false|
|first_name_kana|string|null: false|
|birthday|integer|null: false|
|email|string|null: false|
|password|string|null: false|
|phone_number|string||
### Association
- has_many :items, dependent: :destroy
- has_many :comments, dependent: :destroy
- has_many :favorites, dependent: :destroy
- has_many :reviews, dependent: :destroy
- has_one :destination, inverse_of: :user, dependent: :destroy
- accepts_nested_attributes_for :destination

## destinationsテーブル
|Column|Type|Options|
|------|----|-------|
|destination_family_name|string|null: false|
|destination_first_name|string|null: false|
|destination_family_name_kana|string|null: false|
|destination_first_name_kana|string|null: false|
|postal_code|string|null: false|
|prefecture_id|integer|null: false|
|city|string|null: false|
|street_block|string|null: false|
|mansion_name|string||
|user_id|integer|null: false|
|nickname|string|null: false|
|icon|string||
|introduction|text||
### Association
-  belongs_to :user, inverse_of: :destination

## itemsテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|price|integer|null: false|
|introduction|text|null: false|
|condition|string|null: false|
|day|string|null: false|
|delivery_fee|string|null: false|
|brand|string|
|pref|string|null: false|
|genre_id|integer|null: false, foreign_key: true|
|buyer_id|integer|null: false, foreign_key: true|
|seller_id|integer|null: false, foreign_key: true|
### Association
- belongs_to :user
- has_many :comments, dependent: :destroy
- has_many :favorites, dependent: :destroy
- has_many_attached :images
- belongs_to :genre
- has_many :reviews, dependent: :destroy
- belongs_to :seller
- belongs_to :buyer, optional: true

## genresテーブル
|Column|Type|Options|
|------|----|-------|
|name|string|null: false|
|ancestry|string||
### Association
- has_many :items

## creditcardsテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|string|null: false|
|card_id|string|null: false|
|customer_id|string|null: false|

### Association
- belongs_to :user

## reviewsテーブル
|Column|Type|Options|
|------|----|-------|
|evaluation|string|null: false|
|review|text|null: false|
|user_id|integer|null: false, foreign_key: true|
|item_id|integer|null: false, foreign_key: true|
### Association
- belongs_to :user
- belongs_to :item


## favoritesテーブル
|Column|Type|Options|
|------|----|-------|
|user_id|integer|null: false, foreign_key: true|
|item_id|integer|null: false, foreign_key: true|
### Association
- belongs_to :user
- belongs_to :item

## commentsテーブル
|Column|Type|Options|
|------|----|-------|
|comment|text|null: false|
|user_id|integer|null: false, foreign_key: true|
|item_id|integer|null: false, foreign_key: true|
### Association
- belongs_to :user
- belongs_to :item



This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...


