-- create forum_user
INSERT INTO forum_user
  (username, password_digest, email, img_url)
VALUES
  ('tom', ,'tom@mail.com' , 'http://gdpit.com/avatars_pictures/fun/gdpit_com_55382046_7.jpg'),
  ('jerry', ,'jerry@mail.com' , 'http://gdpit.com/avatars_pictures/fun/gdpit_com_55382046_6.jpg'),
  ('tim', ,'tim@mail.com' , 'http://gdpit.com/avatars_pictures/fun/gdpit_com_55382046_10.jpg'),
  ('james', ,'james@mail.com' , 'http://gdpit.com/avatars_pictures/fun/gdpit_com_55382046_35.jpg'),
  ('larry', ,'larry@mail.com' , 'http://gdpit.com/avatars_pictures/fun/gdpit_com_55382046_14.jpg');

-- create topic
INSERT INTO topic
  (name, description, topic_rate ,img_url, user_id)
VALUES
  ('New York', 

'## Headings *can* also contain **formatting**

### They can even contain `inline code`

2nd paragraph. *Italic*, **bold**, and `monospace`. Itemized lists
look like:

* Another named link to [MarkItDown](http://www.markitdown.net/)
* Sometimes you just want a URL like <http://www.markitdown.net/>.

Note that --- not considering the asterisk --- the actual text
content starts at 4-columns in.',
    12,
    'https://www.burgessyachts.com/media/adminforms/locations/n/e/new_york_1.jpg', 
    1),
  ('New Jersey',
    '## Headings *can* also contain **formatting**

### They can even contain `inline code`

2nd paragraph. *Italic*, **bold**, and `monospace`. Itemized lists
look like:

* Another named link to [MarkItDown](http://www.markitdown.net/)
* Sometimes you just want a URL like <http://www.markitdown.net/>.

Note that --- not considering the asterisk --- the actual text
content starts at 4-columns in.',
    5,
    'http://www.snapshotzphotobooth.com/snapshot-photobooth-rental/photos/site/home-slider-photo-booth-new-jersey.jpg',
    1),
  ('San Fransisco',
    '## Headings *can* also contain **formatting**

### They can even contain `inline code`

2nd paragraph. *Italic*, **bold**, and `monospace`. Itemized lists
look like:

* Another named link to [MarkItDown](http://www.markitdown.net/)
* Sometimes you just want a URL like <http://www.markitdown.net/>.

Note that --- not considering the asterisk --- the actual text
content starts at 4-columns in.',
    10, 
    'http://static1.squarespace.com/static/547f29bfe4b0dc192ed7bdac/54aeb15ce4b018c14f34c7cb/54aeb160e4b018c14f34c7ed/1420734817363/san-franc.jpg?format=2500w',
    2),
  ('Los Angeles',
    '## Headings *can* also contain **formatting**

### They can even contain `inline code`

2nd paragraph. *Italic*, **bold**, and `monospace`. Itemized lists
look like:

* Another named link to [MarkItDown](http://www.markitdown.net/)
* Sometimes you just want a URL like <http://www.markitdown.net/>.

Note that --- not considering the asterisk --- the actual text
content starts at 4-columns in.',
    3,
    'https://laepiclosangeles.com/assets/uploads/los-angeles_2.jpg',
    3);
