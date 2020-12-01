<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Firmar.aspx.cs" Inherits="LockiproTest.Firmar" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>

        <script src="https://mozilla.github.io/pdf.js/build/pdf.js"></script>
    <script src="https://unpkg.com/konva@7.0.3/konva.min.js"></script>

    <style>
        * {
            font-family: 'Averta ☞';
        }

        body {
            background-color: rgba(2, 5, 24, 255);
        }

            body * {
                color: rgba(255, 255, 255, 255);
            }

        input, select {
            background-color: transparent;
            color: rgba(255, 255, 255, 255);
            border-radius: 5px;
            padding: 5px;
            margin: 5px;
        }

        button, #btnEnviar {
            background-color: transparent;
            color: rgba(255, 255, 255, 255);
            border-width: 1px;
            border-color: white;
            border-radius: 25px;
            padding: 10px;
            font-weight: bold;
        }

            button:hover, #btnEnviar:hover {
                background-color: orchid;
                color: rgba(0, 0, 0, 255);
                border-color: black;
                cursor: pointer;
            }

        select:hover {
            cursor: pointer;
        }

        .inputNumber {
            width: 40px;
        }

        .inputFormProperties {
            background-color: rgba(37, 37, 45, 255);
        }

        .linePink {
            color: orchid;
        }

        #divToolbarLeft {
            grid-area: divToolbarLeft;
        }

        #divPdf {
            grid-area: divPdf;
        }

        #divToolbarRight {
            grid-area: divToolbarRight;
            width: 500px;
            margin-left: 700px;
            background-color: rgba(43, 45, 58, 255);
            padding: 25px;
        }

        #Container {
            display: grid;
            grid-template-areas: 'divToolbarLeft divPdf divToolbarRigh';
        }

        #divParentSigners {
            height: 500px;
            padding: 20px;
            overflow-y: scroll;
            background-color: rgba(53, 55, 68, 255);
        }
    </style>
</head>
<body>
    <form id="form1" runat="server" method="get" action="Plantilla.aspx">
        <div>
            <input type="hidden" id = "hiddenText"/>
        </div>
    </form>

    <h1 style="margin-left: 50px;">locki.pro Test</h1>
    <div>
    </div>
    <div id="Container">
        <div id="divToolbarLeft">
        </div>

        <div id="divPdf" style="position: relative;">
            <div id="divCanvas" style="position: absolute; top: 0; left: 0;">
                <canvas id="the-canvas"></canvas>
            </div>
            <div id="containerKonva" style="position: absolute; top: 0; left: 0; z-index: 10;"></div>
        </div>

        <div id="divToolbarRight">
            <label>Pagina:</label>
            <select class="pages" name="pages" id="pagesSelect"></select>
            
            <button id="save">Guardar</button>

            <div id="parentReference">
                <h2>Campos existentes</h2>
                <div id="divReferenceToolbarLeft"></div>
            </div>
            <div id="divParentSigners">
                <div id="divReferenceSigners"></div>
            </div>
        </div>
    </div>

    <script>
        // If absolute URL from the remote server is provided, configure the CORS
        // header on that server.
        var url = 'https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf';

        // Loaded via <script> tag, create shortcut to access PDF.js exports.
        var pdfjsLib = window['pdfjs-dist/build/pdf'];

        // The workerSrc property shall be specified.
        pdfjsLib.GlobalWorkerOptions.workerSrc = 'https://mozilla.github.io/pdf.js/build/pdf.worker.js';

        //array of objects draggeables
        var objectsDragg = [];
        var textsDragg = [];

        //properties for pdf.js
        var pdfDoc = null;
        var scale = 1.3;
        var pageNum = 1;
        var pagesSelect = document.getElementById('pagesSelect');
        var currentPage = 0;
        var ancientPage = 0;
        var existingSigners = document.getElementById('signers');
        var canvas = document.getElementById('the-canvas');
        var context = canvas.getContext('2d');

        //properties for objects draggeables
        var width = window.innerWidth;
        var height = window.innerHeight;

        //create stage for konvas
        var stage = new Konva.Stage({
            container: 'containerKonva',
            width: width,
            height: height,
        });

        //create layer
        var layer = new Konva.Layer();
        stage.add(layer);

        //functino for get the pdf
        pdfjsLib.getDocument(url).promise.then(function (pdfDoc_) {
            pdfDoc = pdfDoc_;

            RenderPage(pageNum);

            var i;
            for (i = 1; i <= pdfDoc.numPages; i++) {
                var option = document.createElement('option');
                option.text = i;
                option.value = i;
                pagesSelect.add(option);
            }

            currentPage = pagesSelect.value;
        });

        //function for render page in the canvas
        function RenderPage(num) {
            // Using promise to fetch the page
            pdfDoc.getPage(num).then(function (page) {
                var viewport = page.getViewport({ scale: scale });
                //set canvas canvas
                canvas.height = viewport.height;
                canvas.width = viewport.width;

                stage.width(viewport.width);
                stage.height(viewport.height);

                var divpdf = document.getElementById('divPdf');
                divpdf.width = viewport.width;
                divpdf.height = viewport.height;

                //render pdf page into canvas context
                var renderContext = {
                    canvasContext: context,
                    viewport: viewport
                }
                var renderTask = page.render(renderContext);
                renderTask.promise.then(function () {
                    console.log('Page rendered');
                });
            });
        }

        //function for change page with select
        function ChangePage() {
            ancientPage = currentPage;
            currentPage = pagesSelect.value;

            //save datas
            //Save();

            //remove objects draggables
            layer.removeChildren();

            //remove properties form
            //CleanPropertiesForm();

            //render the next page
            RenderPage(parseInt(currentPage));
            console.log('pagina ' + currentPage);

            //add existing object
            //AddExistingObjects(currentPage);

            //call method draw from layer for if don't exist an objects update the layer
            layer.draw();
        }
        //assign the function ChangePage to the select
        pagesSelect.addEventListener('change', ChangePage);
    </script>
</body>
</html>
