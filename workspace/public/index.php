<?php

// External access
/*echo
  $_SERVER['SERVER_ADDR'] .' | '.
  gethostbyname($_SERVER['SERVER_NAME']) .' | '.
  $_SERVER['SERVER_NAME'] .' | '.
  gethostname() .' | '.
  gethostbyaddr($_SERVER['REMOTE_ADDR']);*/
  
// Not available (N/A)
$na = "<img src='asset/times.svg' alt='N/A' height='16' width='16' class='align-middle'>";

?>

  <!doctype html>
  <html lang="en">

  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <title>Vagrant (public folder)</title>

    <link rel="stylesheet" href="asset/bootstrap.min.css">
    <link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.2.0/css/all.css">
    <style>
      .container {
        max-width: 50em;
      }
      td:first-child {
        width: 40ch;
      }
    </style>
  </head>

  <body class="pb-5 mb-4">
    <header class="bg-dark text-white mb-5 pt-4 pb-3 sticky-top">
      <div class="container">
        <div class="media">
          <i class="far fa-lightbulb fa-6x"></i>
          <div class="media-body pl-3">
            <h1>Vagrant (public folder) works!</h1>
            <p class="lead">The Virtual Machine is up and running! <i class="fas fa-smile-wink align-middle"></i></p>
          </div>
        </div>
      </div>
    </header>
    <main class="container">
      <h2>Installed software</h2>
      <table class="table table-striped border-bottom mb-5">
        <tr>
          <td>Linux</td>
          <td>
            <?php
              echo (exec('lsb_release -d') ? ltrim(strstr(exec('lsb_release -d'), ":"), ":") : $na);
            ?>
          </td>
        </tr>
        
        <tr>
          <td>Apache</td>
          <td>
            <?php 
              $apache_version = explode( '/', apache_get_version() );
              //echo $apache_version[1];
              echo substr($apache_version[1], 0, strrpos($apache_version[1], " "));
            ?>
          </td>
        </tr>

        <tr>
          <td>PHP</td>
          <td>
            <?php
                $php_version = explode(".", phpversion());
                echo "$php_version[0].$php_version[1]";
            ?>
          </td>
        </tr>

        <tr>
          <td>MySQL</td>
          <td>
            <?php
              if (exec('mysql -V')) {
                  $my_version = explode(" ", exec('mysql -V'));
              }
              echo ($my_version ? $my_version[3] : $na);
            ?>
          </td>
        </tr>

        <tr>
          <td>PostgreSQL</td>
          <td>
            <?php
              if (exec('psql -V')) {
                $pg_version = explode(" ", exec('psql -V'));
              }
              echo ($pg_version ? $pg_version[2] : $na);
            ?>
          </td>
        </tr>
        
        <tr>
          <td>Image Magick</td>
          <td>
            <?php
              //echo (exec('convert -showversion') ? exec('convert -showversion') : 'N/A');
              echo (exec('convert -version') ? exec('convert -version') : $na);
            ?>
          </td>
        </tr>
        
        <tr>
          <td>Memcached</td>
          <td>
            <?php echo ($memcached_version ? $memcached_version : $na); ?>
          </td>
        </tr>
        
        <tr>
          <td>Xdebug</td>
          <td>
            <?php echo (phpversion('xdebug') ? phpversion('xdebug') : $na); ?>
          </td>
        </tr>
        
        <tr>
          <td>??? SSH</td>
          <td>
            <?php echo (exec('ssh -V') ? exec('ssh -V') : $na); ?>
          </td>
        </tr>
        
        <tr>
          <td>Git</td>
          <td>
            <?php
              if (exec('git --version')) {
                $git_version = explode(" ", exec('git --version'));
              }
              echo ($git_version ? $git_version[2] : $na);
            ?>
          </td>
        </tr>
        
        <tr>
          <td>??? Composer</td>
          <td>
            <?php
              if (exec('composer --version')) {
                $composer_version = explode(" ", exec('composer --version'));
              }
              echo ($composer_version ? $composer_version[2] : $na);
            ?>
          </td>
        </tr>
        
        <tr>
          <td>Node.js</td>
          <td>
            <?php echo (exec('nodejs -v') ? ltrim(exec('nodejs -v'), 'v') : $na); ?>
          </td>
        </tr>

        <tr>
          <td>Yarn</td>
          <td>
            <?php echo (exec('yarn -v') ? exec('yarn -v') : $na); ?>
          </td>
        </tr>
        
        <tr>
          <td>MongoDB</td>
          <td>
            <?php echo (exec('mongod --version') ? exec('mongod --version') : $na); ?>
          </td>
        </tr>
      </table>

      <h2>PHP Extensions</h2>
      <table class='table table-striped border-bottom mb-5'>
        <?php
          $php_extension = array(
            "SQLite3" => "sqlite3",
            "GD" => "gd",
            "Multibyte String" => "mbstring",
            "??? OPcache" => "opcache",
            "XML" => "xml",
            "cURL" => "curl",        
            "Zip" => "zip",
            "LDAP" => "ldap",
            "Mcrypt" => "mcrypt",
            "Memcache" => "memcache",
          );
          foreach ($php_extension as $key => $value) {
            (extension_loaded($value) ? $state='check' : $state='times');
            echo "<tr><td>$key</td><td>";
            echo "<img src='asset/$state.svg' alt='N/A' height='16' width='16' class='align-middle'>";
            echo "</td></tr>";
          }
        ?>
      </table>
      
    </main>
    <footer class="bg-dark text-white-50 pt-3 pb-1 mt-5 fixed-bottom">
      <div class="container">
        <p class="text-center">Vagrant stack by VeV-VA Vyškov</p>
      </div>
    </footer>

    <script>
      /*const success = document.querySelectorAll(".fa-check");

      function color() {
        success.forEach(item => item.classList.add('text-success'));
      }

      window.onload = function () {
        color();
      };*/
    </script>
  </body>

  </html>
