# Ruby Guide



## Setup of a blog

see `/setup.sh`

After creating a new blog with `rails new blog` this directory is created.

The blog directory will have a number of generated files and folders that make up the structure of a Rails application. Most of the work in this tutorial will happen in the app folder, but here's a basic rundown on the function of each of the files and folders that Rails creates by default:

|File/Folder |Purpose |
|:--- |:--- |
|app/ |Contains the controllers, models, views, helpers, mailers, channels, jobs, and assets for your application. You'll focus on this folder for the remainder of this guide.|
|bin/ |Contains the rails script that starts your app and can contain other scripts you use to set up, update, deploy, or run your application.|
|config/ |Contains configuration for your application's routes, database, and more. This is covered in more detail in Configuring Rails Applications.|
|config.ru |Rack configuration for Rack-based servers used to start the application. For more information about Rack, see the Rack website.|
|db/  |Contains your current database schema, as well as the database migrations.|
|Gemfile Gemfile.lock |These files allow you to specify what gem dependencies are needed for your Rails application. These files are used by the Bundler gem. For more information about Bundler, see the Bundler website.|
|log/ |Application log files.|
|public/ |Contains static files and compiled assets. When your app is running, this directory will be exposed as-is.|
|Rakefile |This file locates and loads tasks that can be run from the command line. The task definitions are defined throughout the components of Rails. Rather than changing Rakefile, you should add your own tasks by adding files to the lib/tasks directory of your application.|
|README.md |This is a brief instruction manual for your application. You should edit this file to tell others what your application does, how to set it up, and so on.|
|storage/ |Active Storage files for Disk Service. This is covered in Active Storage Overview.|
|test/ |Unit tests, fixtures, and other test apparatus. These are covered in Testing Rails Applications.|
|tmp/ |Temporary files (like cache and pid files).|
|vendor/ |A place for all third-party code. In a typical Rails application this includes vendored gems.|
|.gitattributes |This file defines metadata for specific paths in a git repository. This metadata can be used by git and other tools to enhance their behavior. See the gitattributes documentation for more information.|
|.gitignore |This file tells git which files (or patterns) it should ignore. See GitHub - Ignoring files for more information about ignoring files.|
|.ruby-version |This file contains the default Ruby version.|



## Say Hello!

Let's start by adding a route to our routes file, `config/routes.rb`, at the top of the `Rails.application.routes.draw` block:

```ruby
    Rails.application.routes.draw do
    get "/articles", to: "articles#index"

    # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end

```

## Autoloading

Rails applications do not use require to load application code.

Application classes and modules are available everywhere, you do not need and should not load anything under app with require. This feature is called autoloading, and you can learn more about it in [Autoloading and Reloading Constants](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html).

You only need require calls for two use cases:

- To load files under the lib directory.
- To load gem dependencies that have require: false in the Gemfile.

## MVC

routes, controllers, actions, and views are all typical pieces of a web application that follows the [MVC (Model-View-Controller) pattern](https://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller). MVC is a design pattern that divides the responsibilities of an application to make it easier to reason about. Rails follows this design pattern by convention.

**A model is a Ruby class that is used to represent data. Additionally, models can interact with the application's database through a feature of Rails called Active Record.**
To define a model, we will use the model generator:

```raw
bin/rails generate model Article title:string body:text
```

Model names are singular, because an instantiated model represents a single data record. To help remember this convention, think of how you would call the model's constructor: we want to write `Article.new(...)`, not `Articles.new(...)`.


```raw
invoke  active_record
create    db/migrate/<timestamp>_create_articles.rb
create    app/models/article.rb
invoke    test_unit
create      test/models/article_test.rb
create      test/fixtures/articles.yml
```

## Database Migrations

Migrations are used to alter the structure of an application's database. In Rails applications, migrations are written in Ruby so that they can be database-agnostic.

Let's take a look at the contents of our new migration file:

```ruby
class CreateArticles < ActiveRecord::Migration[7.0]
  def change
    create_table :articles do |t|
      t.string :title
      t.text :body

      t.timestamps
    end
  end
end
```

The call to `create_table` specifies how the articles table should be constructed. By default, the `create_table` method adds an id column as an auto-incrementing primary key.

Note that `title` and `body`were added by the generator because we included them in our generate command (bin/rails generate model Article title:string body:text).

`t.timestamps` is also atuomatically included and defines two additional columns named `created_at` and `updated_at`.


## Using a Model to Interact with the Database

To play with our model a bit, we're going to use a feature of Rails called the console. The console is an interactive coding environment just like `irb`, but it also automatically loads Rails and our application code.

Let's launch the console with this command:

```raw
bin/rails console
```

At this prompt, we can initialize a new Article object:

```irb
 article = Article.new(title: "Hello Rails", body: "I am on Rails!")
```

It's important to note that we have only initialized this object. This object is not saved to the database at all. It's only available in the console at the moment. To save the object to the database, we must call save:

```irb
article.save
```

The output of this should show INSERT INTO "articles" ... database query. This indicates that the article has been inserted into our table. And if we take a look at the article object again, we'll see that it has an `id` and timestamps!

When we want to fetch this article from the database, we can call find on the model and pass the id as an argument:

```irb
Article.find(1)
```

And when we want to fetch all articles from the database, we can call all on the model:

```irb
Article.all
```

## Show a list of articles via th controller

Go to our controller in app/controllers/articles_controller.rb, and change the index action to fetch all articles from the database:

```ruby
class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end
end
```

Controller instance variables can be accessed by the view. That means we can reference @articles in app/views/articles/index.html.erb. Let's open that file, and replace its contents with:

```ruby
<h1>Articles</h1>

<ul>
  <% @articles.each do |article| %>
    <li>
      <%= article.title %>
    </li>
  <% end %>
</ul>
```

The above code is a mixture of HTML and ERB. ERB is a templating system that evaluates Ruby code embedded in a document. Here, we can see two types of ERB tags: `<% %>` and `<%= %>`. The `<% %>` tag means "evaluate the enclosed Ruby code." The `<%= %>` tag means "evaluate the enclosed Ruby code, and output the value it returns." Anything you could write in a regular Ruby program can go inside these ERB tags, though it's usually best to keep the contents of ERB tags short, for readability.

Since we don't want to output the value returned by @articles.each, we've enclosed that code in `<% %>`. But, since we do want to output the value returned by article.title (for each article), we've enclosed that code in `<%= %>`.

With only one article created the visual of these changes are small. Add one more to see that the `.each` loops through all articles.

```raw
Article.new(title: "Secondary Article", body: "Staying on the Rails!")

article.save
```

We can see the final result by visiting <http://localhost:3000>. (Remember that bin/rails server must be running!) Here's what happens when we do that:

1. The browser makes a request: GET <http://localhost:3000>.
2. Our Rails application receives this request.
3. The Rails router maps the root route to the index action of ArticlesController.
4. The index action uses the Article model to fetch all articles in the database.
5. Rails automatically renders the app/views/articles/index.html.erb view.
6. The ERB code in the view is evaluated to output HTML.
7. The server sends a response containing the HTML back to the browser.

We've connected all the MVC pieces together, and we have our first controller action! Next, we'll move on to the second action.

## CRUD

Almost all web applications involve CRUD (Create, Read, Update, and Delete) operations. You may even find that the majority of the work your application does is CRUD. Rails acknowledges this, and provides many features to help simplify code doing CRUD.

Let's begin exploring these features by adding more functionality to our application.

We currently have a view that lists all articles in our database. Let's add a new view that shows the title and body of a single article.

We start by adding a new route that maps to a new controller action (which we will add next). Open `config/routes.rb`, and insert the last route shown here:

```ruby
Rails.application.routes.draw do
  root "articles#index"

  get "/articles", to: "articles#index"
  get "/articles/:id", to: "articles#show"
end
```

The new route is another `get` route, but it has something extra in its path: `:id`. This designates a **route parameter**. A route parameter captures a segment of the request's path, and puts that value into the params Hash, which is accessible by the controller action. For example, when handling a request like `GET http://localhost:3000/articles/1`, 1 would be captured as the value for `:id`, which would then be accessible as `params[:id]` in the show action of `ArticlesController`.

Let's add that show action now to `app/controllers/articles_controller.rb`

```ruby
  def show
    @article = Article.find(params[:id])
  end
```

The show action calls `Article.find` (mentioned previously) with the ID captured by the route parameter. The returned article is stored in the `@article` instance variable, so it is accessible by the view. By default, the show action will render `app/views/articles/show.html.erb`.

Create a new file `app/views/articles/show.html.erb`, with the following contents:

```erb
<h1><%= @article.title %></h1>

<p><%= @article.body %></p>
```

Then we can change up the index view to add links to the articles:

```erb
<h1>Articles</h1>

<ul>
  <% @articles.each do |article| %>
    <li>
      <a href="/articles/<%= article.id %>">
        <%= article.title %>
      </a>
    </li>
  <% end %>
</ul>
```

`<a ...>` creates the link using `href`, we still need to use article.title in the ERB tag to display the correct link text.

## Resourceful Routing

So far, we've covered the "R" (Read) of CRUD. We will eventually cover the "C" (Create), "U" (Update), and "D" (Delete). As you might have guessed, we will do so by adding new **routes, controller actions, and views**. Whenever we have such a combination of routes, controller actions, and views that work together to perform CRUD operations on an entity, we call that entity a **resource**. For example, in our application, we would say an article is a resource.

Rails provides a routes method named resources that maps all of the conventional routes for a collection of resources, such as articles. So before we proceed to the "C", "U", and "D" sections, let's replace the two get routes in `config/routes.rb` with resources:

drop out:

```ruby
get "/articles", to: "articles#index"
get "/articles/:id", to: "articles#show"
```

replace with:

```ruby
resources :articles
```

We can inspect what routes are mapped by running the `bin/rails routes` command.

The `resources` method also sets up URL and path helper methods that we can use to keep our code from depending on a specific route configuration. The values in the "Prefix" column above plus a suffix of `_url` or `_path` form the names of these helpers. For example, the `article_path`helper returns `"/articles/#{article.id}"` when given an article. We can use it to tidy up our links in `app/views/articles/index.html.erb`:

```erb
<h1>Articles</h1>

<ul>
  <% @articles.each do |article| %>
    <li>
      <a href="<%= article_path(article) %>">
        <%= article.title %>
      </a>
    </li>
  <% end %>
</ul>
```

However, we will take this one step further by using the `link_to` helper. The `link_to` helper renders a link with its first argument as the link's text and its second argument as the link's destination. If we pass a model object as the second argument, `link_to` will call the appropriate path helper to convert the object to a path. For example, if we pass an article, `link_to` will call `article_path`. So `app/views/articles/index.html.erb` becomes:

```erb
<h1>Articles</h1>

<ul>
  <% @articles.each do |article| %>
    <li>
        <%= link_to article.title, article %>
    </li>
  <% end %>
</ul>
```


## Creating a New Article

Now we move on to the "C" (Create) of CRUD. Typically, in web applications, creating a new resource is a multi-step process. First, the user requests a form to fill out. Then, the user submits the form. If there are no errors, then the resource is created and some kind of confirmation is displayed. Else, the form is redisplayed with error messages, and the process is repeated.

In a Rails application, these steps are conventionally handled by a controller's `new` and `create` actions. Let's add a typical implementation of these actions to `app/controllers/articles_controller.rb`, below the show action:

```ruby
def new
    @article = Article.new
end

def create
    @article = Article.new(title: "...", body: "...")

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
end
```

The `new` action instantiates a new article, but does not save it. This article will be used in the view when building the form. By default, the new action will render `app/views/articles/new.html.erb`, which we will create next.

The `create` action instantiates a new article with values for the title and body, and attempts to save it. If the article is saved successfully, the action redirects the browser to the article's page at `"http://localhost:3000/articles/#{@article.id}"`. Else, the action redisplays the form by rendering app/views/articles/new.html.erb with status code `422 Unprocessable Entity`. *The title and body here are dummy values. After we create the form, we will come back and change these.*

`redirect_to` will cause the browser to make a new request, whereas `render` renders the specified view for the current request. It is important to use `redirect_to` after mutating the database or application state. Otherwise, if the user refreshes the page, the browser will make the same request, and the mutation will be repeated.

### Form Builder

We will use a feature of Rails called a form builder to create our form. Using a form builder, we can write a minimal amount of code to output a form that is fully configured and follows Rails conventions.

Let's create app/views/articles/new.html.erb with the following contents:

```erb
<h1>New Article</h1>

<%= form_with model: @article do |form| %>
  <div>
    <%= form.label :title %><br>
    <%= form.text_field :title %>
  </div>

  <div>
    <%= form.label :body %><br>
    <%= form.text_area :body %>
  </div>

  <div>
    <%= form.submit %>
  </div>
<% end %>
```

The `form_with` helper method instantiates a form builder. In the `form_with` block we call methods like `label` and `text_field` on the form builder to output the appropriate form elements.

The resulting output from our `form_with` call will look like:

```erb

<form action="/articles" accept-charset="UTF-8" method="post">
  <input type="hidden" name="authenticity_token" value="...">

  <div>
    <label for="article_title">Title</label><br>
    <input type="text" name="article[title]" id="article_title">
  </div>

  <div>
    <label for="article_body">Body</label><br>
    <textarea name="article[body]" id="article_body"></textarea>
  </div>

  <div>
    <input type="submit" name="commit" value="Create Article" data-disable-with="Create Article">
  </div>
</form>

```

[Action View Form Helpers](https://guides.rubyonrails.org/form_helpers.html)

### Using Strong Parameters

Submitted form data is put into the `params` Hash, alongside captured route parameters. Thus, the `create` action can access the submitted title via `params[:article][:title]` and the submitted body via `params[:article][:body]`. We could pass these values individually to `Article.new`, but that would be verbose and possibly error-prone. And it would become worse as we add more fields.

Instead, we will pass a single Hash that contains the values. **However, we must still specify what values are allowed in that Hash. Otherwise, a malicious user could potentially submit extra form fields and overwrite private data.** In fact, if we pass the unfiltered `params[:article]` Hash directly to `Article.new`, Rails will raise a `ForbiddenAttributesError` to alert us about the problem. So we will use a feature of Rails called **Strong Parameters** to filter params. Think of it as strong typing for params.

(what is a "private" method?)
Let's add a private method to the bottom of `app/controllers/articles_controller.rb` named `article_params` that filters `params`. And let's change create to use it:

```ruby

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def article_params
      params.require(:article).permit(:title, :body)
    end
```

Note: we only have these two fields right now. So one of the big benefits in my eyes of using `article_params` is that it limits the number of places additional fields will need to be added/tracked later on if articles becomes more complex.

To learn more about Strong Parameters, see [Action Controller Overview § Strong Parameters](https://guides.rubyonrails.org/action_controller_overview.html#strong-parameters)

### Validations and Displaying Error Messages

As we have seen, creating a resource is a multi-step process. *Handling invalid user input is another step of that process.* Rails provides a feature called validations to help us deal with invalid user input. Validations are rules that are checked before a model object is saved. If any of the checks fail, the save will be aborted, and appropriate error messages will be added to the errors attribute of the model object.

Let's add some validations to our model in app/models/article.rb:

```ruby
class Article < ApplicationRecord
  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }
end
```

The first validation declares that a `title` value must be present. Because title is a string, this means that the title value must contain at least one non-whitespace character.

The second validation declares that a `body` value must also be present. Additionally, it declares that the body value must be at least 10 characters long.

*You may be wondering where the title and body attributes are defined. Active Record automatically defines model attributes for every table column, so you don't have to declare those attributes in your model file.*

With our validations in place, let's modify `app/views/articles/new.html.erb` to display any error messages for `title` and `body`:

```erb
<h1>New Article</h1>

<%= form_with model: @article do |form| %>
  <div>
    <%= form.label :title %><br>
    <%= form.text_field :title %>
    <% @article.errors.full_messages_for(:title).each do |message| %>
      <div><%= message %></div>
    <% end %>
  </div>

  <div>
    <%= form.label :body %><br>
    <%= form.text_area :body %><br>
    <% @article.errors.full_messages_for(:body).each do |message| %>
      <div><%= message %></div>
    <% end %>
  </div>

  <div>
    <%= form.submit %>
  </div>
<% end %>

```



The full_messages_for method returns an array of user-friendly error messages for a specified attribute. If there are no errors for that attribute, the array will be empty.

To understand how all of this works together, let's take another look at the new and create controller actions:

```ruby
  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    if @article.save
      redirect_to @article
    else
      render :new, status: :unprocessable_entity
    end
  end
```

When we visit <http://localhost:3000/articles/new>, the `GET /articles/new` request is mapped to the `new` action. The `new` action does not attempt to save `@article`. Therefore, validations are not checked, and there will be no error messages.

When we submit the form, the `POST /articles` request is mapped to the `create` action. The `create` action does attempt to save `@article`. Therefore, validations are checked. If any validation fails, `@article` will not be saved, and `app/views/articles/new.html.erb` will be rendered with error messages.

Check this!

### Just for fun

At the point I went back to `index.html.erb` to add a sub header above the current articles, and a link to create new ones!

```erb
<h3>Actions</h3>
<p>
    <a href= "/articles/new">
        <%= "Create a New Article"%>
</p>
```

But I forgot to read the last paragraph of the section and there's a beter way using `link_to` ...

```erb
<h1>Articles</h1>

<ul>
  <% @articles.each do |article| %>
    <li>
      <%= link_to article.title, article %>
    </li>
  <% end %>
</ul>

<%= link_to "New Article", new_article_path %>
```

### Update an Article


We've covered the "CR" of CRUD. Now let's move on to the "U" (Update). Updating a resource is very similar to creating a resource. They are both multi-step processes. First, the user requests a form to edit the data. Then, the user submits the form. If there are no errors, then the resource is updated. Else, the form is redisplayed with error messages, and the process is repeated.

These steps are conventionally handled by a controller's `edit` and `update` actions. Let's add a typical implementation of these actions to`app/controllers/articles_controller.rb`, below the create action:

```ruby
  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])

    if @article.update(article_params)
      redirect_to @article
    else
      render :edit, status: :unprocessable_entity
    end
  end
  ```
  
Notice how the `edit` and `update` actions resemble the new and create actions.

The `edit` action fetches the article from the database, and stores it in `@article` so that it can be used when building the form. By default, the edit action will render `app/views/articles/edit.html.erb`.

The `update` action (re-)fetches the article from the database, and attempts to update it with the submitted form data filtered by `article_params`. If no validations fail and the update is successful, the action redirects the browser to the article's page. Else, the action redisplays the form — with error messages — by rendering `app/views/articles/edit.html.erb`.

Our `edit` form will look the same as our `new` form. Even the code will be the same, thanks to the Rails form builder and resourceful routing. The form builder automatically configures the form to make the appropriate kind of request, based on whether the model object has been previously saved.

**The above code is the same as our form in `app/views/articles/new.html.erb`, except that all occurrences of `@article` have been replaced with `article`. Because partials are shared code, it is best practice that they do not depend on specific instance variables set by a controller action. Instead, we will pass the article to the partial as a local variable.**


