<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="LockiproTest.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>PDF Viewer</title>
    <script src="https://mozilla.github.io/pdf.js/build/pdf.js"></script>
    <script src="konva.js"></script>
</head>
<body>
    <h1>locki.pro Test</h1>
    <div>
        <label>Pagina:</label>
        <select class="pages" name="pages" id="pagesSelect"></select>
        <button id="addObject">Agregar objeto</button>
    </div>
    <div style="position: relative;">
        <div id="divCanvas" style="position: absolute; top: 0; left: 0;">
            <canvas id="the-canvas"></canvas>
        </div>
        <div id="containerKonva" style="position: absolute; top: 0; left: 0; z-index: 10;"></div>
    </div>
    <script>
        // If absolute URL from the remote server is provided, configure the CORS
        // header on that server.
        var url = 'https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf';

        // Loaded via <script> tag, create shortcut to access PDF.js exports.
        var pdfjsLib = window['pdfjs-dist/build/pdf'];

        // The workerSrc property shall be specified.
        pdfjsLib.GlobalWorkerOptions.workerSrc = '//mozilla.github.io/pdf.js/build/pdf.worker.js';

        //array of objects draggeables
        var objectsDragg = [];

        //properties for pdf.js
        var pdfDoc = null;
        var scale = 2;
        var pageNum = 1;
        var pagesSelect = document.getElementById('pagesSelect');
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
        });

        //function for render page in the canvas
        function RenderPage(num) {
            // Using promise to fetch the page
            pdfDoc.getPage(num).then(function (page) {
                var viewport = page.getViewport({ scale: scale });
                //set canvas canvas
                canvas.height = viewport.height;
                canvas.width = viewport.width;

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
            RenderPage(parseInt(pagesSelect.value));
            console.log('pagina ' + pagesSelect.value);

            layer.removeChildren();
        }
        //assign the function ChangePage to the select
        pagesSelect.addEventListener('change', ChangePage);

        //function for add a objects draggeables
        var id = 1;
        var rect = null;
        var text = null;

        function AddObjectDraggeable() {
            rect = new Konva.Rect({
                id: 'rect' + id,
                x: 160,
                y: 60,
                width: 100,
                height: 90,
                fill: 'blue',
                name: 'rect',
                stroke: 'black',
                draggable: true,
            });
            layer.add(rect);
            
            //create new transformer
            var transformer = new Konva.Transformer();
            layer.add(transformer);
            transformer.nodes([rect]);
            layer.draw();

            objectsDragg.push(rect);
            id++;

            text = new Konva.Text({
                x: 5,
                y: 5,
            });
            layer.add(text);

            rect.on('transformstart', function () {
                console.log('transform start');
            });

            rect.on('dragmove', function () {
                UpdateText();
                console.log('dragmove')
            });
            rect.on('transform', function () {
                UpdateText();
                console.log('transform');
            });

            rect.on('transformend', function () {
                console.log('transform end');
            });

            rect.on('mouseover', function () {
                document.body.style.cursor = 'pointer';
            });

            rect.on('mouseout', function () {
                document.body.style.cursor = 'default';
            });
        }
        document.getElementById('addObject').addEventListener('click', AddObjectDraggeable);

        //function for update the text with datas of objects
        function UpdateText() {
            var lines = [
                'x: ' + rect.x(),
                'y: ' + rect.y(),
                'rotation: ' + rect.rotation(),
                'width: ' + rect.width(),
                'height: ' + rect.height(),
                'scaleX: ' + rect.scaleX(),
                'scaleY: ' + rect.scaleY(),
            ];
            text.text(lines.join('\n'));
            layer.batchDraw();
        }
    </script>
</body>
</html>
