<?php
error_reporting(E_ALL);
ini_set('display_errors', 1);

$host = getenv('DB_HOST') ?: 'db';
$user = getenv('DB_USER') ?: 'bookstore';
$pass = getenv('DB_PASSWORD') ?: 'bookstore123';
$db = getenv('DB_NAME') ?: 'bookstore_db';

$conn = mysqli_connect($host, $user, $pass, $db);

if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}
?>
