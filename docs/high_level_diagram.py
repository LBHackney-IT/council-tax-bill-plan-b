from diagrams import Diagram
from diagrams.aws.database import Aurora
from diagrams.generic.storage import Storage

graph_attr = {
    "nodesep": "1.00"
}

with Diagram("Hackney Council Tax Billing Plan B", show=True, direction="TB", graph_attr=graph_attr, filename="high_level_diagram"):
    Aurora("POC Data") >> [
        Storage("AWS Academy Recovery\n(October 2020)"),
        Storage("FDM Bill Print Files\n(March 2020)"),
        Storage("FDM Exemption Print Files\n(March 2020)"),
        Storage("Working Age\n(August 2020)"),
        Storage("VO Bands\n(January 2021)"),
        Storage("Direct Debit\nDiscrepancies")
    ]
