<?php
    // Text encoding
    //mb_internal_encoding("utf-8");

    // Email
    $to = "test@example.com";

    // Subject
    $subject = "PHP email test";

    // The unique string, witch will serve as the boundary for the different parts of the email
    $boundary = uniqid('np');

    // Headers
    $headers = "MIME-Version: 1.0\r\n";
    $headers .= "From: Development Team \r\n";
    $headers .= "To: $to\r\n";
    $headers .= "Content-Type: multipart/alternative;boundary=$boundary\r\n";
    $message = "This is a MIME encoded message.";
    $message .= "\r\n\r\n--$boundary\r\n";

    // Plain text version
    $message .= "Content-type: text/plain;charset=utf-8\r\n\r\n";
    $message .= "Hello, World!\n\nThis is the text/plain email version.\n\nRegards,\nDevelopment Team";
    $message .= "\r\n\r\n--$boundary\r\n";

    // HTML version
    $message .= "Content-type: text/html;charset=utf-8\r\n\r\n";
    $message .= '<!doctype html><html><head><meta charset="utf-8"><title>Hello, World!</title></head>';
    $message .= '<body style="font-family: sans-serif;">';
    $message .= '<h1 style="color: #28a745;">Hello, World!</h1>';
    $message .= "<p>This is the <strong style='color: #957bbe;'>HTML</strong> email version.</p>";
    $message .= "<p><em>Regards,<br>Development Team</em></p>";
    $message .= '</body></html>';
    $message .= "\r\n\r\n--$boundary--";

    // Send email
    try {
        echo("\n");
        if (!mail($to, $subject, $message, $headers))
            throw new Exception("The email can not be sent!");
        echo("The email sent. Did he come?\n\n");
    }
    catch (Exception $e) {
        echo("Error: ". $e->getMessage() . "\n\n");
    }

?>