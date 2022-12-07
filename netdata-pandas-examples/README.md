# netdata-pandas

[netdata-pandas](https://github.com/netdata/netdata-pandas/tree/master/) is a Python package that can be used to pull data from you Netdata nodes into a [Pandas](https://pandas.pydata.org/pandas-docs/stable/index.html) DataFrame beloved by all.

## Contents

In this directory there are a number of sample [Jupyter](https://jupyter.org/) notebooks showing some usage of the netdata-pandas package.

- [anomalies_collector_deepdive.ipynb](anomalies_collector_deepdive.ipynb): A deepdive tutorial that goes under the hood a bit on whats going on in the Netdata [anomalies collector](https://github.com/andrewm4894/netdata/tree/anomalies-collector/collectors/python.d.plugin/anomalies) (view on nbviewer [here](https://nbviewer.jupyter.org/github/netdata/community/blob/main/netdata-agent-api/netdata-pandas/anomalies_collector_deepdive.ipynb)).
- [anomaly_detection.ipynb](anomaly_detection.ipynb): A notebook that pulls some recent data from a specific node and runs it though various anomaly detection algorithms using the awesome [ADTK](https://adtk.readthedocs.io/en/stable/index.html) library (view on nbviewer [here](https://nbviewer.jupyter.org/github/netdata/community/blob/main/netdata-agent-api/netdata-pandas/anomaly_detection.ipynb)).
- [correlation_heatmap.ipynb](correlation_heatmap.ipynb): A notebook that pulls some recent data from multiple hosts and plots some pretty correlation heatmaps (view on nbviewer [here](https://nbviewer.jupyter.org/github/netdata/community/blob/main/netdata-agent-api/netdata-pandas/anomaly_detection.ipynb)). 
 

## Getting Started

To run the notebooks you have two options:

(1) run in your own python environment making sure to install all the dependencies listed in [requirements.txt](requirements.txt) 

or

(2) run each notebook in [Google Colab](https://colab.research.google.com/) by pressing the "Open in Colab" button at the top of each notebook. Once the notebook is opened in Google Colab you will then just need to uncomment the first code cell to install the relevant python packages for that notebook into the environment Google Colab has spun up for you (**note**: Google Colab offers free notebooks in the cloud so can be a great way to start playing with Python without having to worry about setting up your own Python environment on you computer). 
