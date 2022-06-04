#!/bin/bash

listBook() {
  echo "Listing the books...";
  echo ""

  # read from the book.csv
  while IFS=, read -r book_id title author stock publisher
  do
    echo "Book ID: $book_id";
    echo "Title: $title";
    echo "Author: $author";
    echo "Stock: $stock";
    echo "Publisher: $publisher";
    echo "";
  done < <(tail -n +2 books.csv)

}

addBook() {
  echo "Add New Book";
 
  local id="";
  local title="";
  local author="";
  local stock="";
  local publisher="";

  echo "Enter the book id: ";
  read id;
  echo "Enter the book title: ";
  read title;
  echo "Enter the book author: ";
  read author;
  echo "Enter the book stock: ";
  read stock;
  echo "Enter the book publisher: ";
  read publisher;

  # write to the book.csv

  echo
  echo "ID: $id";
  echo "Title: $title";
  echo "Author: $author";
  echo "Stock: $stock";
  echo "Publisher: $publisher";
  
  echo
  echo "$id,$title,$author,$stock,$publisher" >> books.csv;

  echo "Book added!";
}

editBook() {
  echo "Edit Book";
}

deleteBook() {
  local id="";
  echo "Delete Book";
  echo "Enter the book id: ";
  read id;

  local found=0;

  # remove from the books.csv
  while IFS=, read -r book_id title author stock publisher
  do
    if [ "$book_id" = "$id" ]; then
      sed -i "${LINENO}d" books.csv;
      found=1;
      echo "Book deleted!";
    fi
  done < <(tail -n +2 books.csv)

  if [ $found -eq 0 ]; then
    echo "Book not found!";
  fi
}

showBook() {
  local id="";
  echo "Enter the book id: ";
  read id;

  local found=0;

  # read from the books.csv
  while IFS=, read -r book_id title author stock publisher
  do
    if [ "$book_id" == "$id" ]; then
      echo ""
      echo "Book ID: $book_id";
      echo "Title: $title";
      echo "Author: $author";
      echo "Stock: $stock";
      echo "Publisher: $publisher";
      echo "";
      found=1;
    fi
  done < <(tail -n +2 books.csv)

  if [ $found -eq 0 ]; then
    echo ""
    echo "Book not found!";
  fi

  echo "";
}

command=$1;

case $command in
  list)
    listBook
    ;;
  add)
    addBook $@
    ;;
  edit)
    editBook $@
    ;;
  delete)
    deleteBook $@
    ;;
  show)
    showBook $@
    ;;
  *)
    echo "Unknown command";
    echo "Usage: $0 {list|add|edit|delete|show}";
    ;;
esac