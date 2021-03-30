# Postgres Database Schema

## `users`
Table `users` stores user and user session information.

|column name|data type|details|
|-|-|-|
|*id*|*integer*|*not null, primary key*|
|email|string|not null, indexed, unique|
|password_digest|string|not null|
|session_token|string|not null, indexed, unique|
|*created_at*|*datetime*|*not null*|
|*updated_at*|*datetime*|*not null*|
- index on `email, unique: true`
- index on `session_token, unique: true`

## `files`
Table `files` stores user ownership and default page width/height information.

|column name|data type|details|
|-|-|-|
|*id*|*integer*|*not null, primary key*|
|owner_id|integer|not null, indexed, **foreign key**|
|width|integer|not null|
|height|integer|not null|
|*created_at*|*datetime*|*not null*|
|*updated_at*|*datetime*|*not null*|
- `owner_id` references `users`
- index on `owner_id`

## `slides`
Table `slices` stores the slides in relation to files and their display orders(page numbers).

|column name|data type|details|
|-|-|-|
|*id*|*integer*|*not null, primary key*|
|file_id|integer|not null, indexed, **foreign key**|
|page_num|integer|not null|
|*created_at*|*datetime*|*not null*|
|*updated_at*|*datetime*|*not null*|
- `file_id` references `files`
- index on `file_id`

## `orders`
Table `orders` stores the display orders of different objects within a same slide.
|column name|data type|details|
|-|-|-|
|*id*|*integer*|*not null, primary key*|
|slide_id|integer|not null, indexed, **foreign key**|

- `slide_id` references `slides`
- index on `slide_id`

## `groups`
Table `groups` stores the groups in relation to display orders.

|column name|data type|details|
|-|-|-|
|*id*|*integer*|*not null, primary key*|
|order_id|integer|not null, indexed, **foreign key**|
|transform_string|string|not null|
|*created_at*|*datetime*|*not null*|
|*updated_at*|*datetime*|*not null*|
- `order_id` references `orders, unique: true`
- index on `order_id`

## `wrappers`
Table `wrappers` stores the presentation element wrappers in relation to display orders.
|column name|data type|details|
|-|-|-|
|*id*|*integer*|*not null, primary key*|
|group_id|integer|indexed, **foreign key**|
|order_id|integer|not null, indexed, **foreign key**|
|type|string|not null|
|width|integer|not null|
|height|integer|not null|
|transform_string|string|not null|
|*created_at*|*datetime*|*not null*|
|*updated_at*|*datetime*|*not null*|
- `group_id` references `groups`
- index on `group_id`
- `order_id` references `orders, unique: true`
- index on `order_id`
- `type` includes `["diagram", "image", "text", "group"]`  

## `shapes`
Table `shapes` stores the geometric shapes in relation to wrappers, as well as their styles.

|column name|data type|details|
|-|-|-|
|*id*|*integer*|*not null, primary key*|
|wrapper_id|integer|not null, indexed, **foreign key**|
|type|string|not null|
|path_string|text|not null|
|style_string|text|not null|
|*created_at*|*datetime*|*not null*|
|*updated_at*|*datetime*|*not null*|
- `wrapper_id` references `wrappers`
- index on `wrapper_id, unique: true`

## `images`
Table `images` stores the images in relation to wrappers, as well as their actual sizes, crops, and styles 
|column name|data type|details|
|-|-|-|
|*id*|*integer*|*not null, primary key*|
|wrapper_id|integer|not null, indexed, **foreign key**|
|url/blob|TBD|not null|
|width|integer|not null|
|height|integer|not null|
|offset_x|integer|not null|
|offset_y|integer|not null|
|scale_x|integer|not null|
|scale_y|integer|not null|
|style_string|text|not null|
|*created_at*|*datetime*|*not null*|
|*updated_at*|*datetime*|*not null*|
- `wrapper_id` references `wrappers`
- index on `wrapper_id, unique: true`

## `text_boxes`
Table `text_boxes` stores textboxes in relation to wrappers, as well as the text contents.

|column name|data type|details|
|-|-|-|
|*id*|*integer*|*not null, primary key*|
|wrapper_id|integer|not null, indexed, **foreign key**|
|text|text|not null|
|*created_at*|*datetime*|*not null*|
|*updated_at*|*datetime*|*not null*|
- `wrapper_id` references `wrappers`
- index on `wrapper_id, unique: true`

## `text_styles`
Table `text_styles` stores the text styles and their locations(offsets) in relation to wrappers.
|column name|data type|details|
|-|-|-|
|*id*|*integer*|*not null, primary key*|
|textbox_id|integer|not null, indexed, **foreign key**|
|style_string|text|not null|
|offset|integer|not null|
|*created_at*|*datetime*|*not null*|
|*updated_at*|*datetime*|*not null*|
- `textbox_id` references `textboxs`
- index on `textbox_id`
