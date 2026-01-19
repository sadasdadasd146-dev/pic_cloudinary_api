class User < ApplicationRecord
  has_many :media, class_name: "Medium", dependent: :destroy

  has_many :images,
           -> { where(media_type: 'image') },
           class_name: 'Medium'

  has_many :videos,
           -> { where(media_type: 'video') },
           class_name: 'Medium'






           
end
