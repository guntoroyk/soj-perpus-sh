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

  # check existing book id  
  local found=0
  while IFS=, read -r book_id title author stock publisher
  do
    if [ "$book_id" == "$id" ]; then
      found=1
      break;
    fi
  done < <(tail -n +2 books.csv)
  
  if [ $found -eq 1 ]; then
    echo "Book with ID: $id already exist";
    return;
  fi

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
  local id="";
  echo "Enter the book id want to edit: ";
  read id;

  local found=0;
  local index=2;

  # edit from the books.csv
   while IFS=, read -r book_id title author stock publisher
  do
    if [ "$book_id" = "$id" ]; then
      echo ""
      echo "Book ID: $book_id";
      echo "Title: $title";
      echo "Author: $author";
      echo "Stock: $stock";
      echo "Publisher: $publisher";
      echo "";

      # delete the book from the books.csv
      sed -i "${index}d" books.csv;
      found=1;
      break;
    fi
    index=$(expr $index + 1);
  done < <(tail -n +2 books.csv)

  if [ $found -eq 0 ]; then
    echo "Book not found!";
    return;
  fi

  echo "Enter the new title: ";
  read title;
  echo "Enter the new author: ";
  read author;
  echo "Enter the new stock: ";
  read stock;
  echo "Enter the new publisher: ";
  read publisher;

  # write to the books.csv
  echo ""
  echo "$id,$title,$author,$stock,$publisher" >> books.csv;

}

deleteBook() {
  local id="";
  echo "Enter the book id want to delete: ";
  read id;

  local found=0;
  local index=2

  # remove from the books.csv
  while IFS=, read -r book_id title author stock publisher
  do
    if [ "$book_id" = "$id" ]; then
      sed -i "${index}d" books.csv;
      found=1;
      echo "Book deleted!";
    fi
    index=$(expr $index + 1);
  done < <(tail -n +2 books.csv)

  if [ $found -eq 0 ]; then
    echo "Book not found!";
  fi
}

showBook() {
  local id="";
  echo "Enter the book id want to show: ";
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
