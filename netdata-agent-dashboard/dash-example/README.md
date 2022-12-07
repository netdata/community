# Dash (Multi-Host Dashboard)

`dash-example.html` is a single file, all-in-one page that automatically fetches graphs from all your hosts. Just add your graphs and charts (or use the defaults) one time using the `dash-*` syntax, and your selections will be automatically replicated for all of your hosts; showing alarms and graphs for all your hosts on **one page!**

For example, below shows a parent node called "devml-master" with multiple children streaming to it ("devml", "devml1", "devml2" etc.).

![alt text](https://user-images.githubusercontent.com/2178292/147828981-8a471305-efc0-4ad3-ad01-d2b7a02491b3.png)

__**Dash will only work if you have implemented [netdata streaming](https://learn.netdata.cloud/docs/agent/streaming) using `stream.conf`. It is not part of Netdata Cloud.**__

`dash-example.html` was created as an experiment to demonstrate the capabilities of netdata in a multi-host environment. If you desire more features, submit a pull request or check out [Netdata Cloud!](https://www.netdata.cloud/cloud/)

## Configure Dash

First, copy the `dash-example.html` file to a location in your netdata web directory or to any other webserver. For instance, with a webroot at `/usr/share/netdata/web`:
```bash
cp /tmp/dash-example.html /usr/share/netdata/web/dash.html
```

> NOTE: Ensure the owner/permissions match those in the rest of the files in the directory. For the netdata web directory, this is usually `netdata:netdata` and `0644`. Typically a command like this should do it `sudo chown -R netdata:netdata /usr/share/netdata/web/`

Once this is done you should be able to see the new custom dashboard on your parent host at `https://localhost:19999/dash.html` (restart netdata using `sudo systemctl restart netdata` if needed).

> NOTE: Depending on your parent configuration, uou may need to use the actual ip address of the parent instead of `localhost` in the `dash.html` file.

Find and change the following lines in your new `dash.html` to reflect your Netdata URLs. The `REVERSE_PROXY_URL` is optional and only used if you access your Netdata dashboard through a reverse proxy. If it is not set, it defaults to the `NETDATA_HOST` URL.

```js
/**
 * Netdata URLS. If you use a reverse proxy, add it and uncomment the line below
 */
NETDATA_HOST = 'https://localhost:19999';
// REVERSE_PROXY_URL = 'https://my-domain.com/stats'
```

To change the sizes of graphs and charts, find the `DASH_OPTIONS` object in `dash.html` and set your preferences:
```js
/*
 * Change your graph/chart dimensions here. Host columns will automatically adjust.  
 * Charts are square! Their width is the same as their height.
 */
DASH_OPTIONS = {
    graph_width: '40em',
    graph_height: '20em',
    chart_width: '10em' // Charts are square
}
```

See the configuration section at the top of `dash.html` for more options.

To change the display order of your hosts, which is saved in localStorage, click the settings gear in the lower right corner


## The `dash-*` Syntax

If you want to change the graphs or styling to fit your needs, just add an element to the page as shown. Child divs will be generated to create your graph/chart, and charts are replicated for each streamed host.
```
<div class="dash-graph"                     <----     Use class dash-graph for line graphs, etc
    data-dash-netdata="system.cpu"          <----     REQUIRED: Use data-dash-netdata to set the data source
    data-dygraph-valuerange="[0, 100]">     <----     OPTIONAL: This overrides the default config. Any other data-* attributes will
</div>                                                          be added to the generated div, so you can set any desired options here

<div class="dash-chart"                     <----     Use class dash-chart for pie charts, etc. CHARTS ARE SQUARE
    data-dash-netdata="system.io"           <----     REQUIRED: Use data-dash-netdata to set the data source
    data-dimensions="in"                    <----     Use this to override or append default options
    data-title="Disk Read"                  <----     Use this to override or append default options
    data-common-units="dash.io">            <----     Use this to override or append default options
</div>
```

We hope you like it!
