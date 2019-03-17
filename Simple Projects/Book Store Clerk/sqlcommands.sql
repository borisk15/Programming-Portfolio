create database if not exists ebookstore;

use ebookstore;

create table books (
 	id int NOT NULL AUTO_INCREMENT, 
 	Title varchar(100), 
 	Author varchar(60), 
 	Qty int, 
 	primary key (id)
);

ALTER TABLE books AUTO_INCREMENT = 3001;

insert into books values (3001, 'A Tale of Two Cities', 'Charles Dickens', 30), 
 	(3002, 'Harry Potter and the Philosopher''s Stone', 'J.K.Rowling', 40), 
 	(3003, 'The Lion, the Witch and the Wardrobe', 'C. S. Lewis', 25), 
 	(3004, 'The Lord of the Rings', 'J.R.R Tolkien', 37), 
 	(3005, 'Alice in Wonderland', 'Lewis Carroll', 12);

