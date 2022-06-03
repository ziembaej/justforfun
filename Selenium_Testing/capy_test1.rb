require 'capybara'
require 'selenium-webdriver'

def test_comment_count_shows_on_index

  @blog_post = BlogPost.create!(

    title: "My first post!",

    body: "Please add a comment!"

  )

  visit(blog_post_path(@blog_post))

  fill_in "#new_comment", with: "This blog post is awesome!"

  click_on "#submit"

  assert page.has_selector?("#confirmation_message") # Capybara handles the waiting for us

  visit(blog_posts_path)

  post_summary = page.first(".blog-post-summary")

  post_summary.assert_selector '.subheading', text: "1 comment"

end