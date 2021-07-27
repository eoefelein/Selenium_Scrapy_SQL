# pylint: skip-file
import os
import pandas as pd

import dash
import dash_html_components as html
import dash_core_components as dcc

import plotly
import plotly.express as px
import plotly.graph_objs as go
from plotly.graph_objs import *
import plotly.offline as offline
from plotly.offline import download_plotlyjs, init_notebook_mode, plot, iplot

mapbox_access_token = os.getenv("MAPBOX_TOKEN")
df = pd.read_csv("app/clean_df.csv")


def calculate_rolling_avg_column(df, column, new_column):
    df[new_column] = None
    for idx, row in df[[column, "createdat"]].iterrows():
        subset = df[~(row["createdat"] < df["createdat"])]
        df.at[idx, new_column] = "{:.2f}".format(subset[column].mean())
    return df[new_column]


trending_avg_price = calculate_rolling_avg_column(df, "price", "trending_avg_price")
trending_avg_area = calculate_rolling_avg_column(df, "area", "trending_avg_area")
trending_avg_price_per_sq_ft = calculate_rolling_avg_column(
    df, "price_per_sq_ft", "trending_avg_price_per_sq_ft"
)

df = df[df["property_type"] != "Land"]
df.property_type.unique()

colors = [
    "#995fb0",
    "#fcc7b0",
    "#d685a0",
    "#fcedb0",
    "#b0ecfc",
    "#5f9fb0",
    "#f66970",
    "#fb9663",
    "#f66970",
    "#f26fd3",
    "#9f4d88",
    "#889f4d",
    "#294727",
]
trace3 = go.Pie(
    labels=list(dict(df["property_type"].value_counts()).keys()),
    values=list(dict(df["property_type"].value_counts()).values()),
    marker=dict(colors=colors, line=dict(color="#000000", width=2)),
    name="Property Type",
)


df = df.sort_values(by="createdat")


import dash
import dash_html_components as html
import dash_core_components as dcc
from dash.dependencies import Input, Output, State, ClientsideFunction

app = dash.Dash(__name__,)

server = app.server
app.config.suppress_callback_exceptions = True

layout = dict(
    autosize=True,
    automargin=True,
    margin=dict(l=30, r=30, b=20, t=40),
    hovermode="closest",
    plot_bgcolor="#F9F9F9",
    paper_bgcolor="#e5e5dc",
    legend=dict(font=dict(size=10), orientation="h"),
    title="Satellite Overview",
    mapbox=dict(
        accesstoken=mapbox_access_token,
        style="light",
        center=dict(lon=-78.05, lat=42.54),
        zoom=7,
    ),
)

indicators = ["trending_avg_price", "trending_avg_area", "trending_avg_price_per_sq_ft"]

app.layout = html.Div(
    [
        # empty Div to trigger javascript file for graph resizing
        html.Div(id="output-clientside"),
        html.Div(
            [
                html.Div([], className="one-third column",),
                html.Div(
                    [
                        html.Div(
                            [
                                html.H3(
                                    "Tiny House Nation: The SQL",
                                    style={
                                        "font-size": "68px",
                                        "margin-bottom": "5px",
                                        "font-family": "Courier New",
                                    },
                                ),
                            ]
                        )
                    ],
                    className="one-half column",
                    id="title",
                ),
                html.Div(
                    [
                        html.A(
                            html.Button("See the Source", id="learn-more-button"),
                            href="https://tinyhouselistings.com/",
                        )
                    ],
                    className="one-third column",
                    id="button",
                ),
            ],
            id="header",
            className="row flex-display",
            style={"margin-bottom": "25px"},
        ),
        html.Div(
            [
                html.Div(
                    html.P(
                        "This project looks at the emerging tiny house trend, clustering homes by price, square footage and property type to understand where and how this trend is being realized across the country. Click the stack icon to the right of the Tiny House Clusters map to view each cluster. The designated states within each layer are the states for which the desingated variable proved to be spatially correlated.",
                        style={"font-family": "Courier New"},
                    ),
                    className="pretty_container four columns",
                    id="cross-filter-options",
                ),
                html.Div(
                    [
                        html.Div(
                            [
                                html.Div(
                                    [
                                        html.H6(id="well_text"),
                                        html.P(
                                            "No. of Tiny Homes : 10,000",
                                            style={"font-family": "Courier New"},
                                        ),
                                    ],
                                    id="wells",
                                    className="mini_container",
                                ),
                                html.Div(
                                    [
                                        html.H6(id="gasText"),
                                        html.P(
                                            "Average Area (sq. ft.): 238 sq. ft.",
                                            style={"font-family": "Courier New"},
                                        ),
                                    ],
                                    id="gas",
                                    className="mini_container",
                                ),
                                html.Div(
                                    [
                                        html.H6(id="oilText"),
                                        html.P(
                                            "Average Price: $42,182.03",
                                            style={"font-family": "Courier New"},
                                        ),
                                    ],
                                    id="oil",
                                    className="mini_container",
                                ),
                                html.Div(
                                    [
                                        html.H6(id="waterText"),
                                        html.P(
                                            "Average Price per square foot : $196.60 per sq. ft.",
                                            style={"font-family": "Courier New"},
                                        ),
                                    ],
                                    id="water",
                                    className="mini_container",
                                ),
                            ],
                            id="info-container",
                            className="row container-display",
                        ),
                    ],
                    id="right-column",
                    className="eight columns",
                ),
            ],
            className="row flex-display",
        ),
        html.Div(
            [
                html.Div(
                    children=[
                        html.H1(
                            children="Tiny House Clusters",
                            style={"font-family": "Courier New"},
                        ),
                        html.Iframe(
                            id="tiny-cluster-map",
                            srcDoc=open("app/Tiny_House_Cluster.html", "r").read(),
                            width="100%",
                            height="600",
                        ),
                    ],
                    className="pretty_container twelve columns",
                ),
            ],
            className="row flex-display",
        ),
        html.Div(
            [
                html.Div(
                    [
                        html.Div(
                            [
                                dcc.Graph(
                                    id="tiny-pie-graph",
                                    figure={
                                        "data": [trace3],
                                        "layout": dict(
                                            title="Tiny House Property Types",
                                            font=dict(family="Courier New"),
                                            legend=dict(
                                                orientation="h",
                                                fontsize="12px",
                                                yanchor="center",
                                                x="1",
                                            ),
                                        ),
                                    },
                                )
                            ],
                            className="pretty_container four columns",
                        ),
                        html.Div(
                            children=[
                                html.H1(
                                    children="Tiny House Growth Over Time",
                                    style={"font-family": "Courier New"},
                                ),
                                html.Iframe(
                                    id="tiny-scatter-map",
                                    srcDoc=open(
                                        "app/Tiny_House_Scatter.html", "r"
                                    ).read(),
                                    width="100%",
                                    height="600",
                                ),
                            ],
                            className="pretty_container five columns",
                        ),
                        html.Div(
                            [
                                dcc.Dropdown(
                                    id="selected_variable",
                                    options=[
                                        {"label": k, "value": k} for k in indicators
                                    ],
                                    value="trending_avg_price",
                                ),
                                dcc.Graph(id="tiny-line-chart",),
                            ],
                            className="pretty_container three columns",
                        ),
                    ],
                    id="main-container",
                    className="row container-display",
                ),
            ],
            id="left-column",
            className="pretty_container twelve columns",
        ),
    ]
)


@app.callback(
    dash.dependencies.Output("tiny-line-chart", "figure"),
    dash.dependencies.Input("selected_variable", "value"),
)
def update_figure(selected_variable):
    line_df = df[["createdat", selected_variable]]
    figure = {
        "data": [
            go.Scatter(
                x=line_df["createdat"], y=line_df[selected_variable], mode="lines"
            )
        ],
        "layout": go.Layout(
            title=("Trending Tiny House Stats"), font=dict(family="Courier New")
        ),
    }
    return figure


if __name__ == "__main__":
    app.run_server(debug=True, host="0.0.0.0", port=8080, use_reloader=False)
