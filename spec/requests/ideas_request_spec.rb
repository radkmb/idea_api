require "rails_helper"

RSpec.describe "Ideas", type: :request do
  fixtures :categories
  fixtures :ideas
  describe "GET #index" do
    it "全てのideaが表示される" do
      get :"/ideas"
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["date"].count).to eq(2)
    end
    it "指定したcategoryのみのideaが表示される" do
      get :"/ideas", params: { category_name: "app" }
      expect(response.status).to eq(200)
      expect(JSON.parse(response.body)["date"].count).to eq(1)
    end
    it "未登録categoryのリクエストは404を返す" do
      get :"/ideas", params: { category_name: "存在しないカテゴリ" }
      expect(response.status).to eq(404)
    end
  end
  describe "POST #create" do
    it "categoryがない場合の新規作成に成功する" do
      post :"/ideas", params: { category_name: "web", body: "ファッション情報" }
      expect(response.status).to eq(201)
      expect(Category.find_by(name: "web")).to be_present
      expect(Idea.find_by(body: "ファッション情報")).to be_present
    end
    it "categoryがある場合の新規作成に成功する" do
      post :"/ideas", params: { category_name: "app", body: "天体観測" }
      expect(response.status).to eq(201)
      expect(Idea.find_by(body: "天体観測")).to be_present
    end
    it "categoryのvalidationをチェックする" do
      post :"/ideas", params: { body: "ファッション情報" }
      expect(response.status).to eq(422)
    end
    it "ideaのvalidationをチェックする" do
      post :"/ideas", params: { category_name: "app2" }
      expect(response.status).to eq(422)
    end
  end
end
