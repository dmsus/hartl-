require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:michael)
	end

	test "micropost interface" do
		log_in_as(@user)
		get root_path
		assert_select 'div.pagination'
		assert_no_difference 'Micropost.count' do
			post microposts_path, micropost: { content: ""}
		end
		assert_select 'div#error_explanation'
		content = "This micropost really ties the room together"
		assert_difference 'Micropost.count', 1 do
			post microposts_path, micropost: {content: content}
		end
		assert_redirected_to root_url
		follow_redirect!
		assert_match content, response.body
		assert_select 'a', text: 'delete'
		first_micropost = @user.microposts.paginate(pageL 1).first
		assert_difference 'Micropost.count', -1 do
			delete microposts_path(first_micropost)
		end
		get user_path(users(:archer))
		assert_select 'a', text: 'delete', count: 0
	end
end