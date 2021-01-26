from diagrams import Diagram
from diagrams.aws.database import Aurora
from diagrams.generic.storage import Storage

graph_attr = {
    "nodesep": "1.00"
}

with Diagram("\nHackney Council Tax Billing Plan B", show=True, direction="TB", graph_attr=graph_attr, filename="high_level_diagram"):
    poc = Aurora("POC Data")
    poc << Storage("AWS Academy Recovery\n(October 2020)")
    poc << Storage("FDM Bill Print Files\n(March 2020)")
    poc << Storage("FDM Exemption Print Files\n(March 2020)")
    poc << Storage("Working Age\n(August 2020)")
    Storage("Valuation Office Bands\n(2020/21)") >> poc
    Storage("Direct Debit\nDiscrepancies\n(2020/21)") >> poc
    Storage("Cash Payments\n(April 2020 -\nDecember 2020)") >> poc
    Storage("Recently Deceased\n(December 2020 -\nJanuary 2021)") >> poc
