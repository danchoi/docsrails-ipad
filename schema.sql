

create table pages (
  item_id text,
  page_title text,
  title text,
  slug text,
  description text,
  source text, 
  parent_item_id text
);

create unique index pages_page_id_idx on pages (item_id);
create index pages_title_idx on pages (title);

