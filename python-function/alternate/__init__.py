from time import sleep
import json
import azure.functions as func

def main(req: func.HttpRequest) -> func.HttpResponse:
    sleep(0.75)
    return func.HttpResponse(
        json.dumps({
            'id': req.params.get('id')
        })
    )