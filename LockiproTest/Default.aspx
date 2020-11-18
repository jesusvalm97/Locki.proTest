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
        <select class="pages" name="pages" id="pagesSelect">
        </select>
    </div>
    <div id="divCanvas">
        <canvas id="the-canvas"></canvas>
    </div>
    <div>
        <button id="btnAddObject">Agregar objeto</button>
    </div>
    <div id="container"></div>

    <script>
        // If absolute URL from the remote server is provided, configure the CORS
        // header on that server.
        var url = 'https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf';

        // Loaded via <script> tag, create shortcut to access PDF.js exports.
        var pdfjsLib = window['pdfjs-dist/build/pdf'];

        // The workerSrc property shall be specified.
        pdfjsLib.GlobalWorkerOptions.workerSrc = '//mozilla.github.io/pdf.js/build/pdf.worker.js';


        var pdfDoc = null;
        var scale = 2;
        var pageNum = 1;
        var pagesSelect = document.getElementById('pagesSelect');
        var canvas = document.getElementById('the-canvas');
        var context = canvas.getContext('2d');

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
        }
        //assign the function ChangePage to the select
        pagesSelect.addEventListener('change', ChangePage);

        //test for konva
        var width = window.innerWidth;
        var height = window.innerHeight;

        var stage = new Konva.Stage({
            container: 'container',
            width: width,
            height: height,
        });

        var layer = new Konva.Layer();
        stage.add(layer);

        var rect = new Konva.Rect({
            x: 160,
            y: 60,
            width: 100,
            height: 90,
            fill: 'red',
            name: 'rect',
            stroke: 'black',
            draggable: true,
        });
        layer.add(rect);

        var text = new Konva.Text({
            x: 5,
            y: 5,
        });
        layer.add(text);
        updateText();

        // create new transformer
        var tr = new Konva.Transformer();
        layer.add(tr);
        tr.nodes([rect]);
        layer.draw();

        rect.on('transformstart', function () {
            console.log('transform start');
        });

        rect.on('dragmove', function () {
            updateText();
        });
        rect.on('transform', function () {
            updateText();
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

        function updateText() {
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

        function AddObjectDraggeable() {
            var circle = new Konva.Circle({
                x: 160,
                y: 60,
                width: 100,
                height: 90,
                fill: 'blue',
                name: 'circle',
                stroke: 'black',
                draggable: true,
            });
            layer.add(circle);
            console.log('agregado circulo');

            // create new transformer
            var transformer = new Konva.Transformer();
            layer.add(transformer);
            transformer.nodes([circle]);
            layer.draw();

            console.log('agregado transformer');
        }
        document.getElementById('btnAddObject').addEventListener('click', AddObjectDraggeable);
    </script>
</body>
</html>
