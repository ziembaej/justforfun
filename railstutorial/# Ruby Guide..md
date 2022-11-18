# Ruby Guide

Working through this guide from [rubyonrails.org](https://guides.rubyonrails.org/autoloading_and_reloading_constants.html)


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

### Database Migrations

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


### Using a Model to Interact with the Database

To play with our model a bit, we're going to use a feature of Rails called the console. The console is an interactive coding environment just like `irb`, but it also automatically loads Rails and our application code.

Let's launch the console with this command:

```raw
bin/rails console
```

At this prompt, we can initialize a new Article object:

```ruby
 article = Article.new(title: "Hello Rails", body: "I am on Rails!")
```

It's important to note that we have only initialized this object. This object is not saved to the database at all. It's only available in the console at the moment. To save the object to the database, we must call save:

```ruby
article.save
```

The output of this should show INSERT INTO "articles" ... database query. This indicates that the article has been inserted into our table. And if we take a look at the article object again, we'll see that it has an `id` and timestamps!

When we want to fetch this article from the database, we can call find on the model and pass the id as an argument:

```ruby
Article.find(1)
```

And when we want to fetch all articles from the database, we can call all on the model:

```ruby
Article.all
```

### Show a list of articles via th controller

Go to our controller in app/controllers/articles_controller.rb, and change the index action to fetch all articles from the database:

```ruby
class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end
end
```

Controller instance variables can be accessed by the view. That means we can reference @articles in app/views/articles/index.html.erb. Let's open that file, and replace its contents with:

```html
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

```html
<h1><%= @article.title %></h1>

<p><%= @article.body %></p>
```

Then we can change up the index view to add links to the articles:

```html
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

### Resourceful Routing

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

```html
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

```html
<h1>Articles</h1>

<ul>
  <% @articles.each do |article| %>
    <li>
        <%= link_to article.title, article %>
    </li>
  <% end %>
</ul>
```


### Creating a New Article

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

```html
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

```html

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

```html
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

```html
<h3>Actions</h3>
<p>
    <a href= "/articles/new">
        <%= "Create a New Article"%>
</p>
```

But I forgot to read the last paragraph of the section and there's a beter way using `link_to` ...

```html
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


Let's update app/views/articles/new.html.erb to use the partial via render:

```html
<h1>New Article</h1>

<%= render "form", article: @article %>
```

*A partial's filename must be prefixed with an underscore, e.g. _form.html.erb. But when rendering, it is referenced without the underscore, e.g. render "form".*

And now, let's create a very similar app/views/articles/edit.html.erb:

```html
<h1>Edit Article</h1>

<%= render "form", article: @article %>
```

We can now update an article by visiting its edit page, e.g. <http://localhost:3000/articles/1/edit>. To finish up, let's link to the edit page from the bottom of `app/views/articles/show.html.erb`:

### Delete an Article

Finally, we arrive at the "D" (Delete) of CRUD. Deleting a resource is a simpler process than creating or updating. It only requires a route and a controller action. And our resourceful routing (`resources :articles`) already provides the route, which maps `DELETE /articles/:id` requests to the destroy action of `ArticlesController`.

So, let's add a typical destroy action to `app/controllers/articles_controller.rb`, below the update action:


```ruby
  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    redirect_to root_path, status: :see_other
  end
```

The `destroy` action fetches the article from the database, and calls [destroy](https://api.rubyonrails.org/v7.0.4/classes/ActiveRecord/Persistence.html#method-i-destroy) on it. Then, it redirects the browser to the root path with status code 303 See Other.

We have chosen to redirect to the root path because that is our main access point for articles. But, in other circumstances, you might choose to redirect to e.g. `articles_path`.

Now let's add a link at the bottom of `app/views/articles/show.html.erb` so that we can delete an article from its own page:

```html
    <li><%= "Destroy", article_path(@article), data: {
            turbo_method: :delete,
            turbo_confirm: "Are you sure?" 
            } %></li>
```

In the above code, we use the `data` option to set the `data-turbo-method` and `data-turbo-confirm` HTML attributes of the "Destroy" link. Both of these attributes hook into [Turbo](https://turbo.hotwired.dev/), which is included by default in fresh Rails applications. `data-turbo-method="delete"` will cause the link to make a `DELETE` request instead of a `GET` request. `data-turbo-confirm="Are you sure?"` will cause a confirmation dialog to appear when the link is clicked. If the user cancels the dialog, the request will be aborted.

## Adding a Second Model

It's time to add a second model to the application. The second model will handle comments on articles.

### Generating a Model

We're going to see the same generator that we used before when creating the Article model. This time we'll create a Comment model to hold a reference to an article. Run this command in your terminal:

```raw
bin/rails generate model Comment commenter:string body:text article:references
```

This is very similar to the `Article` model that you saw earlier. The difference is the line `belongs_to :article`, which sets up an *Active Record* association. You'll learn a little about associations in the next section of this guide.

The (:references) keyword used in the shell command is a special data type for models. It creates a new column on your database table with the provided model name appended with an `_id` that can hold integer values. To get a better understanding, analyze the `db/schema.rb` file after running the migration.

In addition to the model, Rails has also made a migration to create the corresponding database table in `db/schema.rb`.

The migration file is `db/migrate/TIMESTAMP_create_comments.rb`

The `t.references` line creates an integer column called `article_id`, an index for it, and a foreign key constraint that points to the id column of the `articles` table.

Run the migration using:

```raw
bin/rails db:migrate
```

**Rails is smart enough to only execute the migrations that have not already been run against the current database. Essentially the `generate model` line preps the model, and `db:migrate` runs any migration from new models**


### Associating Models

Active Record associations let you easily declare the relationship between two models. In the case of `comments` and `articles`, you could write out the relationships this way:

- Each comment belongs to one article.
- One article can have many comments.

In fact, this is very close to the syntax that Rails uses to declare this association. You've already seen the line of code inside the `Comment` model (`app/models/comment.rb`) that makes each comment belong to an Article. *Note that this association is the same as concept as a many:1 relationship*


You'll need to edit `app/models/article.rb` to add the other side of the association by including:

```ruby
  has_many :comments
```

These two declarations (Comment `belongs_to :article` and Article `has_many :comments`) enable a good bit of automatic behavior. For example, if you have an instance variable `@article` containing an article, you can retrieve all the comments belonging to that article as an array using `@article.comments`.

### Adding a Route for Comments

As with the `articles` controller, we will need to add a route so that Rails knows where we would like to navigate to see comments. Open up the `config/routes.rb` file again, and edit it as follows:

Update

```ruby
resources :articles
```

to become

```ruby
resources :articles do
    resources :comments
end
```

This creates `comments` as a nested resource within `articles`. This is another part of capturing the **hierarchical relationship that exists between articles and comments.**


### Generating a Controller

With the model in hand, you can turn your attention to creating a matching controller. Again, we'll use the same generator we used before:

```raw
bin/rails generate controller Comments
```

Like with any blog, our readers will create their comments directly after reading the article, and once they have added their comment, will be sent back to the article show page to see their comment now listed. Due to this, our `CommentsController` is there to provide a method to create comments and delete spam comments when they arrive.

So first, we'll wire up the Article show template (app/views/articles/show.html.erb) to let us make a new comment add the following:

```html
<h2>Add a comment:</h2>
<%= form_with model: [ @article, @article.comments.build ] do |form| %>
  <p>
    <%= form.label :commenter %><br>
    <%= form.text_field :commenter %>
  </p>
  <p>
    <%= form.label :body %><br>
    <%= form.text_area :body %>
  </p>
  <p>
    <%= form.submit %>
  </p>
  <% end %>
  ```

This adds a form on the `Article` show page that creates a new comment by calling the `CommentsController` `create` action. The `form_with` call here uses an array, which will build a nested route, such as `/articles/1/comments`.

Let's wire up the create in `app/controllers/comments_controller.rb`:

```ruby
class CommentsController < ApplicationController
  def create
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end

  private
    def comment_params
      params.require(:comment).permit(:commenter, :body)
    end
end
```

- **Why does the show page use comments.build, when we're creating comments.create here????**

You'll see a bit more complexity here than you did in the controller for articles. That's a side-effect of the nesting that you've set up. Each request for a comment has to keep track of the article to which the comment is attached, thus the initial call to the `find` method of the `Article` model to get the article in question.

In addition, the code takes advantage of some of the methods available for an association. We use the `create` method on `@article.comments` to create and save the comment. This will automatically link the comment so that it belongs to that particular article.

Once we have made the new comment, we send the user back to the original article using the `article_path`(`@article`) helper. As we have already seen, this calls the show action of the `ArticlesController` which in turn renders the `show.html.erb` template. This is where we want the comment to show, so let's add that to the `app/views/articles/show.html.erb`.

```html
<h2>Comments</h2>
<% @article.comments.each do |comment| %>
  <p>
    <strong>Commenter:</strong>
    <%= comment.commenter %>
  </p>

  <p>
    <strong>Comment:</strong>
    <%= comment.body %>
  </p>
<% end %>
```

---

**When testing this I found that I cannot destroy and article that has comments. I will need to update that later, but might happen as part of the tutorial anyways.**

---

## Refactoring

### Rendering Partial Collections

First, we will make a comment partial to extract showing all the comments for the article. Create the file `app/views/comments/_comment.html.erb` and put the following into it:

```html
<p>
  <strong>Commenter:</strong>
  <%= comment.commenter %>
</p>

<p>
  <strong>Comment:</strong>
  <%= comment.body %>
</p>
```

Then you can change `app/views/articles/show.html.erb` to show the following for the Comments block

```html
<h2>Comments</h2>
<%= render @article.comments %>
```

This will now render the partial in `app/views/comments/_comment.html.erb` once for each comment that is in the `@article.comments` collection. As the `render` method iterates over the `@article.comments` collection, it assigns each comment to a local variable named the same as the partial, in this case comment, which is then available in the partial for us to show.

### Rendering a Partial Form

Let us also move that new comment section out to its own partial. Again, you create a file `app/views/comments/_form.html.erb` containing:

```html
<%= form_with model: [ @article, @article.comments.build ] do |form| %>
  <p>
    <%= form.label :commenter %><br>
    <%= form.text_field :commenter %>
  </p>
  <p>
    <%= form.label :body %><br>
    <%= form.text_area :body %>
  </p>
  <p>
    <%= form.submit %>
  </p>
<% end %>
```

Then you make the `app/views/articles/show.html.erb` look like the following:

```html
<h1><%= @article.title %></h1>

<p><%= @article.body %></p>

<ul>
  <li><%= link_to "Edit", edit_article_path(@article) %></li>
  <li><%= link_to "Destroy", article_path(@article), data: {
                    turbo_method: :delete,
                    turbo_confirm: "Are you sure?"
                  } %></li>
</ul>

<h2>Comments</h2>
<%= render @article.comments %>

<h2>Add a comment:</h2>
<%= render 'comments/form' %>
```

The second `render` just defines the partial template we want to render, `comments/form`. Rails is smart enough to spot the forward slash in that string and realize that you want to render the `_form.html.erb` file in the `app/views/comments` directory.

The `@article` object is available to any partials rendered in the view because we defined it as an instance variable.

- WHY can `_comment.html.erb` be called as part of `@article` where the `_form.html.erb` cannot? I tried renaming it and that didn't work, so it's not just because there is another file called `_form.html.erb` ...

### Using Concerns

Concerns are a way to make large controllers or models easier to understand and manage. This also has the advantage of reusability when multiple models (or controllers) share the same concerns. *Concerns* are implemented using *modules* that contain *methods* representing a well-defined slice of the functionality that a model or controller is responsible for. In other languages, modules are often known as mixins.

You can use concerns in your controller or model the same way you would use any module. When you first created your app with `rails new blog`, two folders were created within app/ along with the rest:

```raw
app/controllers/concerns
app/models/concerns
```

In the example below, we will implement a new feature for our blog that would benefit from using a concern. Then, we will create a concern, and refactor the code to use it, making the code more DRY and maintainable.

A blog article might have various statuses - for instance, it might be visible to everyone (i.e. `public`), or only visible to the author (i.e. `private`). It may also be hidden to all but still retrievable (i.e. `archived`). Comments may similarly be hidden or visible. This could be represented using a `status` column in each model.

#### First, let's run the following migrations to add status to Articles and Comments:

```raw
bin/rails generate migration AddStatusToArticles status:string
bin/rails generate migration AddStatusToComments status:string
```

And next, let's update the database with the generated migrations:

```raw
bin/rails db:migrate
```

We need to add `:status` to the parameters for both controllers for `Articles` and `Comments`

i.e.

```ruby
  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end
```

AND:

```ruby
  private
    def article_params
      params.require(:article).permit(:title, :body, :status)
    end

```

Next we need to add statuses to each model, `article.rb` and `comment.rb`:

```ruby
class Article < ApplicationRecord
  has_many :comments

  validates :title, presence: true
  validates :body, presence: true, length: { minimum: 10 }

  VALID_STATUSES = ['public', 'private', 'archived']

  validates :status, inclusion: { in: VALID_STATUSES }

  def archived?
    status == 'archived'
  end
end
```

AND:

```ruby
class Comment < ApplicationRecord
  belongs_to :article

  VALID_STATUSES = ['public', 'private', 'archived']

  validates :status, inclusion: { in: VALID_STATUSES }

  def archived?
    status == 'archived'
  end
end
```

Then, in our index action template (`app/views/articles/index.html.erb`) we would use the `archived?` method to avoid displaying any article that is archived:

```html
...

  <% @articles.each do |article| %>
    <% unless article.archived? %>
      <li>
        <%= link_to article.title, article %>
      </li>
    <% end %>
...

```


Similarly, in our comment partial view (`app/views/comments/_comment.html.erb`) we would use the `archived?` method to avoid displaying any comment that is archived. Wrap this around the current comment partial view:

```html
<% unless comment.archived? %>

...

<% end %>
```

However, if you look again at our models now, you can see that the logic is duplicated. If in the future we increase the functionality of our blog - to include private messages, for instance - we might find ourselves duplicating the logic yet again. This is where concerns come in handy.


### Improve the idea of archiving by building a model for visibility


A concern is only responsible for a focused subset of the model's responsibility; the methods in our concern will all be related to the visibility of a model. Let's call our new concern (module) `Visible`. We can create a new file inside `app/models/concerns` called `visible.rb` , and store all of the status methods that were duplicated in the models.

app/models/concerns/visible.rb

```ruby
module Visible
  def archived?
    status == 'archived'
  end
end
```

We can add our status validation to the concern, but this is slightly more complex as validations are methods called at the class level. The `ActiveSupport::Concern` ([API Guide](https://api.rubyonrails.org/v7.0.4/classes/ActiveSupport/Concern.html)) gives us a simpler way to include them:


Now, we can remove the duplicated logic from each model and instead include our new Visible module:

```ruby
include Visible
```

Class methods can also be added to concerns. If we want to display a count of public articles or comments on our main page, we might add a class method to Visible as follows:

```ruby
  class_methods do
    def public_count
      where(status: 'public').count
    end
  end
```

Then in the view, you can call it like any class method:

```html
<h1>Articles</h1>

Our blog has <%= Article.public_count %> articles and counting!

<ul>
  <% @articles.each do |article| %>
    <% unless article.archived? %>
      <li>
        <%= link_to article.title, article %>
      </li>
    <% end %>
  <% end %>
</ul>

<%= link_to "New Article", new_article_path %>
```

