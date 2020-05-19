class IdeasController < ApplicationController
  def index
    # ideaの一覧を返す
    ideas = Idea.all
    # category_nameがあるならそのcategoryのideaを返す
    if params["category_name"]
      category = Category.find_by(name: params["category_name"])
      if category.blank?
        render nothing: true, status: :not_found
        return
      end
      ideas = ideas.where(category_id: category.id)
    end
    results = []
    ideas.each do |idea|
      results.append({
                       id: idea.id,
                       category: Category.find(idea.category_id).name,
                       body: idea.body
                     })
    end
    render json: { date: results }
  end

  def create
    category = Category.find_by(name: params["category_name"])

    unless category
      category = Category.new(name: params["category_name"])
      # ideaモデルを保存
      unless category.save
        render nothing: true, status: :unprocessable_entity
        return
      end
    end

    idea = Idea.new(category_id: category.id, body: params["body"])
    unless idea.save
      render nothing: true, status: :unprocessable_entity
      return
    end

    render nothing: true, status: :created
  end
end
