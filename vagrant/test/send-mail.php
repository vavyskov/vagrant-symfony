<?php
    // Text encoding
    //mb_internal_encoding("utf-8");

    // Email address
    $from = "devel@example.com";
    $to = "test@example.com";

    // Subject
    $subject = "PHP email test";

    // The unique string, witch will serve as the boundary for the different parts of the email
    $boundary = uniqid('np');

    // Headers
    $headers = "MIME-Version: 1.0\r\n";
    $headers .= "From: $from\r\n";
    $headers .= "Content-Type: multipart/alternative;boundary=$boundary\r\n";

    // Message - info
    $message = "This is a MIME encoded message.";
    $message .= "\r\n\r\n--$boundary\r\n";

    // Message - TEXT version
    $message .= "Content-type: text/plain;charset=utf-8\r\n\r\n";
    $message .= "E-mail works!\n\nThis is the text/plain email version.\n\nRegards,\nDevelopment Team";
    $message .= "\r\n\r\n--$boundary\r\n";

    // Message - HTML version
    $message .= "Content-type: text/html;charset=utf-8\r\n\r\n";
    $message .= "<!doctype html><html><head><meta charset='utf-8'>\r\n";
    $message .= "<title>E-mail works!</title><style>\r\n";
    $message .= "html {height: 100%;}\r\n";
    $message .= "body {margin: 0; background-image: linear-gradient(to bottom right, #ffffff, #62d1e2); font-family: -apple-system,BlinkMacSystemFont,'Segoe UI',Roboto,'Helvetica Neue',Arial,sans-serif,'Apple Color Emoji','Segoe UI Emoji','Segoe UI Symbol','Noto Color Emoji';}\r\n";
    $message .= ".container {max-width: 50em; margin-left: auto; margin-right: auto; padding-left: 15px; padding-right: 15px}\r\n";
    $message .= "header {background-color: #343a40; color: #fff; padding-top: 1em; padding-bottom: 1em;}\r\n";
    $message .= "main {}\r\n";
    $message .= "</style></head><body>\r\n";
    $message .= "<header><div class='container'><table><tr>\r\n";
    $message .= "<td><img style='margin-left: -15px;' src='data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAGAAAABgCAMAAADVRocKAAABvFBMVEUAAAD///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////+q2OmUAAAAk3RSTlMAAQIDBAUGBwgJCgwODxAREhMUFRYXGBkaGxwdHiAhIiMkJSYpKissLzM0Njg6Ozw9PkBBQkZHS01OT1BRUlRWWFlbXF1eX2FiZmdsbXFzdHV3eHl7f4KFiYuMjo+RkpSYmpudoKKjpaaoqqutr7CytLW3ur7Bw8XHyMrMz9HV19nc3uDi5Obo6evt7/Hz9ff5+/0BJuQbAAAD1klEQVQYGbXBjV9TVQAG4PfubsLQRAZiARaKCCKVlEYiWoF9EB+hEaWQgTlUBEVJsDvEwhZjk8V8/+Hqd84ZDMY95+7M54GpyPHukRlvLZtd82ZGuo9HUE7OO9++4C6rA2+jTA4NpFlUeuAQ7DU+oI8HjbBTv0CNhXqULjJOA+MRlOh0mkbSrSiFM0ZjYw4CCz9kofmrp6ojDuBEqk9dnWeheRcBVaxwp6lWFwXc1inutFKBQMIet6W/OIAiDvRluM1zEYDzhHlbfSHsI9S/xbwnDsyNMi9eCR+VceaNwlgbldfnoXH+NZU2GHJTlNLHoHUsQynlwswQpUwNDNRkKA3CyEEqDTDSQOUgTFyj1A1D3ZRGYSCSo7CAvWLexvLMUFslCj2mkAtD7xNKb2Evj8KzLgc7HKZ0AXqPKdxAER6VP1uwwwSFR9CKUKpBETGPeYPYVkMpAp0WCs+xj1D12ckt/u9HbFul0AKdKxT64MO9sMH/XEJeP4Ve6ExSOAFf7hTJrQooLRRuQuc3ClH4c+ZIXoFSRWEROn9QCEGjnuQClBCFVehsUoBOiOQ68ii8gs4/FKDlkR7yKGShk6TgQCfmeTEoDoWX0HlGIYpAohSWofMLhXcRyHsUfobONxT6EEg/ha+h00ZhBYE8p3AaOlFKtQigjlIltBIUJhDABAUPepcp1cJYLaVe6EUpLTkw5CxTisLAJKVBGBqidBMmqql8ACMfUjkMI2NUWmGglcr3MBP+m1KuEVpNOUrJMAydpJKNQSOWpXICxr6ikorCV1WKypcIYJLKkgMfoWUqkwjCeUTlJ/i4QeWhg0DcBJVO7Ot9KgkXAVUmKWWj2EdVllKyEoEdzVGawz7mKeXqUIJOKh0o6iyVTpRklNJ6CEW4KUrfoTROgtJnKOJzSgkHJTpKaTOMPcJZSnUo2TVKPdjjEqVRlC78isJL7Ob8RSEThoVPKTVjl5OUumHDWafwA3YZp7DuwMpFCpsOCjibFC7CToTSERSooRSBpWkKH6HAxxSmYauLwjAKjFA4B1tHKNxDgXsUqmErTF9hWHKn6GvKhZ1ZaszCSge1OmDjLrXuwkaSWknY2KBWCjbi1LoDG+3UaoeVODXisBOnRhxW2qnVDhtxat2BjQ1qpWAjSa0kbMxQawY2zlDrDKzcp8Z92An9Sl+3Q7DUTF/NsHWLvm7B1hp9rcHWBn2lYGuOvmZhq4u+zsGWs0gfi7Dn3ua+pl2UQ8P1RJZ7ZBPXG1A+Hnf5HeXVwF0aUGaXWaAXZdfDHXrwBtQ/pfS0Hm9G0/BSJrM03IQA/gWiyS2k+MPnxwAAAABJRU5ErkJggg==' alt='lightbulb'></td>\r\n";
    $message .= "<td><h1>E-mail works!</h1></td>\r\n";
    $message .= "</tr></table></div></header>\r\n";
    $message .= "<main class='container'>\r\n";
    $message .= "<p>This is the <strong>HTML</strong> email version.</p>\r\n";
    $message .= "<p><em>Regards,<br>Development Team</em></p>\r\n";
    $message .= "</main></body></html>\r\n\r\n--$boundary--";

    // Send email
    try {
        echo("\n");
        if (!mail($to, $subject, $message, $headers))
            throw new Exception("The email can not be sent!");
        echo("The mail sent. Did mail arrive into mailbox?\n\n");
    }
    catch (Exception $e) {
        echo("Error: ". $e->getMessage() . "\n\n");
    }

?>