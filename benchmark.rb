require 'rails/all'
Bundler.require(*Rails.groups)

ActiveRecord::Base.logger = nil
ActiveModelSerializers.logger = nil

class Comment < Struct.new(:id, :author, :comment, keyword_init: true)
  def self.model_name
    'Comment'
  end

  def read_attribute_for_serialization(attr)
    public_send(attr)
  end
end


class Post < Struct.new(:id, :title, :body, :created_at, :updated_at, :comments, keyword_init: true)
  def self.model_name
    'Post'
  end

  def read_attribute_for_serialization(attr)
    public_send(attr)
  end
end

class CommentSerializer < ActiveModel::Serializer
  attributes :id, :author, :comment
end

class PostSerializer < ActiveModel::Serializer
  attributes :id,
             :title, :body,
             :created_at, :updated_at

  has_many :comments, each_serializer: CommentSerializer
end

def build_comment
  Comment.new(
    id: SecureRandom.uuid,
    author: SecureRandom.alphanumeric(10),
    comment: SecureRandom.alphanumeric(10),
  )
end

def build_post(comment_size: 0)
  Post.new(
    id: SecureRandom.uuid,
    title: SecureRandom.alphanumeric(10),
    body: SecureRandom.alphanumeric(10),
    created_at: Time.current,
    updated_at: Time.current,
    comments: comment_size.times.map { build_comment }
  )
end


def serialize_ams(data)
  ActiveModelSerializers::SerializableResource.new(
    data,
    include: 'comments',
    serializer: ActiveModel::Serializer::CollectionSerializer,
    each_serializer: PostSerializer
  ).as_json
end

class CommentResource < Keema::Resource
  field :id, String
  field :author, String
  field :comment, String
end

class PostResource < Keema::Resource
  field :id, String
  field :title, String
  field :body, String
  field :created_at, Time
  field :updated_at, Time
  field :comments, [CommentResource]
end

def serialize_keema(data)
  PostResource.serialize(data)
end

data = 10.times.map { build_post(comment_size: 10) }

unless serialize_ams(data).to_json == serialize_keema(data).to_json
  raise 'json mismatch'
end

%i[ips memory].each do |bench|
  Benchmark.send(bench) do |x|
    x.config(time: 10, warmup: 5, stats: :bootstrap, confidence: 95) if x.respond_to?(:config)

    x.report('ams') do
      serialize_ams(data)
    end
    x.report('keema') do
      serialize_keema(data)
    end

    x.compare!
  end
end
