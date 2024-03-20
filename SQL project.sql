create database mapping;
show databases;

use mapping;

create table actor(act_id integer primary key,act_fname char(20),act_lname char(20),act_gender char(1));
desc actor;
create table movie(mov_id integer primary key,mov_title char(50),mov_year integer,mov_time integer,mov_lang char(50),mov_dt_rel date,mov_rel_country char(5));
 desc movie;
 create table director(dir_id integer primary key,dir_fname char(20),dir_lname char(20));

desc director;
create table genres(gen_id integer primary key,gen_title char(20));
desc genres;
create table reviewer(rev_id integer primary key,rev_name char(30));
desc reviewer;
create table movie_cast(act_id integer,mov_id integer,role char(30),foreign key(act_id) references actor(act_id),foreign key(mov_id) references movie(mov_id));
desc movie_cast;
create table movie_direction(dir_id integer,mov_id integer,foreign key(dir_id) references director(dir_id),foreign key(mov_id)  references movie(mov_id));
desc movie_direction;
create table movie_genres(mov_id integer,gen_id integer,foreign key(mov_id)  references movie(mov_id),foreign key(gen_id)  references genres(gen_id));
desc movie_genres;
create table rating(mov_id integer,rev_id integer,rev_stars integer,num_o_ratings integer,foreign key(mov_id)  references movie(mov_id),foreign key(rev_id)  references reviewer(rev_id));
desc rating;
show tables;
