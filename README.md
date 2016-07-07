Hekad Docker Image
==================
Description
-----------
This module contains Hekad log forwarder

Configuration parameters
------------------------

## The more flexible way of configuring container ##
* **config** - defines the hekad source config file
    Example: -e config=/path/hekad.toml

## The following options are more restricting regarding their configuration options - less tested ##
* **input** - defines the source input to capture the logs from:
    * **docker** - use hekad input module [DockerInputLog](http://hekad.readthedocs.io/en/latest/config/inputs/docker_log.html)
    * **file** -  use hekad input module [Logstreamer](http://hekad.readthedocs.io/en/latest/config/inputs/logstreamer.html))
        When setting the input=log you have to configure the following parameters:
           * **log_directory** (string) - The root directory to scan files from. This scan is recursive so it should be suitably restricted to the most specific directory this selection of logfiles will be matched under. The log_directory path will be prepended to the file_match.
           * **file_match** (string) - Regular expression used to match files located under the log_directory. This regular expression has $ added to the end automatically if not already present, and log_directory as the prefix. WARNING: file_match should typically be delimited with single quotes, indicating use of a raw string, rather than double quotes, which require all backslashes to be escaped. For example, ‘access\.log’ will work as expected, but “access\.log” will not, you would need “access\\.log” to achieve the same result.
           * **priority**  (list of strings) - When using sequential logstreams, the priority is how to sort the logfiles in order from oldest to newest.
           * **differentiator** - When using multiple logstreams, the differentiator is a set of strings that will be used in the naming of the logger, and portions that match a captured group from the file_match will have their matched value substituted in. Only the last (according to priority) file per differentiator is kept opened.
           * **hostname** (string) - The hostname to use for the messages, by default this will be the machine’s qualified hostname. This can be set explicitly to ensure it’s the correct name in the event the machine has multiple interfaces/hostnames.
    * **tcp** - use hekad input module [TcpInput](http://hekad.readthedocs.io/en/latest/config/inputs/tcp.html)
        * **receiver_port** - optional port, default is 5565
* **output** - defines the target output of the logs:
    * **tcp** - use hekad output module [TcpOutput](http://hekad.readthedocs.io/en/latest/config/outputs/tcp.html)
        Configure the following:
        * **log_output_tcp_address** - tcp output address:port
    * **file** - use hekad output module [FileOutput](http://hekad.readthedocs.io/en/latest/config/outputs/file.html)
        Consider configuring the following:
        * **log_output_path** - Full path to the output file. If date rotation is in use, then the output file path can support strftime syntax to embed timestamps in the file path: http://strftime.org
        * **log_output_perm** - File permission for writing. A string of the octal digit representation. Defaults to “644”.
        * **log_output_folder_perm** - Permissions to apply to directories created for FileOutput’s parent directory if it doesn’t exist. Must be a string representation of an octal integer. Defaults to “700”.
        * **flush_count** - Number of messages to accumulate until file data should be written to disk (default 100).
    
    
    



Docker Image Run
----------------

1) docker run -d -e config=/path/hekad.toml

2) docker run -d -e input=file -e log_directory=/var/logs -e file_match='(?P<FileName>[^/]+)\.log(\.(?P<Year>\d{4})-(?P<Month>\d{2})-(?P<Day>\d{2})\.(?P<Seq>\d*))?' -e priority=["Year", "Month", "Day", "^Seq"] -e differentiator=["FileName"] -e output=tcp -e log_output_tcp_address=hekad-receiver-host:5566

