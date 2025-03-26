<?php
header('Content-Type: application/json');

$status = 'healthy';
$message = 'Application is running';

// Check database connection
try {
    include 'config.php';
    mysqli_ping($conn);
} catch (Exception $e) {
    $status = 'unhealthy';
    $message = 'Database connection failed';
    http_response_code(503);
}

// Check if Apache is running
if (function_exists('apache_get_modules')) {
    echo "Apache is running\n";
} else {
    http_response_code(500);
    echo "Apache is not running\n";
    exit(1);
}

echo json_encode([
    'status' => $status,
    'message' => $message,
    'timestamp' => date('Y-m-d H:i:s')
]); 