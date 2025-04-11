USE ig_clone;

#LOYAL USERS
SELECT id, username, created_at
FROM users
ORDER BY created_at ASC
LIMIT 5;


#INACTIVE USERS
SELECT users.id, users.username, users.created_at
from users
LEFT JOIN photos
ON users.id=photos.user_id
WHERE photos.id IS NULL;


SELECT users.id, users.username, COUNT(photos.id) AS total_photos
FROM users
LEFT JOIN photos ON users.id = photos.user_id
WHERE users.id IN (SELECT users.id FROM users LEFT JOIN photos ON users.id = photos.user_id WHERE photos.id IS NULL)
GROUP BY users.id, users.username;


#CONTEST WINNER 
SELECT users.id, users.username, photos.id AS photo_id, COUNT(likes.user_id) AS total_likes
FROM photos
JOIN users ON photos.user_id = users.id
JOIN likes ON photos.id = likes.photo_id
GROUP BY photos.id, users.id, users.username
ORDER BY total_likes DESC
LIMIT 1;

#POPULAR HASHTAGS
SELECT tags.tag_name, COUNT(photo_tags.tag_id) AS total_usage
FROM tags
JOIN photo_tags ON tags.id = photo_tags.tag_id
GROUP BY tags.tag_name
ORDER BY total_usage DESC
LIMIT 5;

#MOST LOGGED IN USER DAY
SELECT DAYNAME(created_at) AS registration_day, COUNT(id) AS total_users
FROM users
GROUP BY registration_day
ORDER BY total_users DESC
LIMIT 1;


#PHOTOS PER USER
SELECT 
  (SELECT COUNT(*) FROM photos) AS total_photos,
  (SELECT COUNT(*) FROM users) AS total_users,
  (SELECT COUNT(*) FROM photos) / (SELECT COUNT(*) FROM users) AS photos_per_user_ratio;

#BOT DETECTION
# Count Total Photos on Instagram 
SELECT COUNT(*) FROM photos;

# Count How Many Photos Each User Has Liked
SELECT user_id, COUNT(*) AS likes_given
FROM likes
GROUP BY user_id;

#Find Users Who Have Liked All Photos
SELECT user_id
FROM likes
GROUP BY user_id
HAVING COUNT(*) = (SELECT COUNT(*) FROM photos);

# Get User Details
SELECT u.id, u.username
FROM users u
WHERE u.id IN (
    SELECT user_id
    FROM likes
    GROUP BY user_id
    HAVING COUNT(*) = (SELECT COUNT(*) FROM photos)
);

