﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="LockiproTest.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>PDF Viewer</title>
    <script src="https://mozilla.github.io/pdf.js/build/pdf.js"></script>
    <script src="konva.js"></script>

    <style>
        #divToolbarLeft {
            grid-area: divToolbarLeft;
        }

        #divPdf {
            grid-area: divPdf;
        }

        #divToolbarRight {
            grid-area: divToolbarRight;
        }

        #Container {
            display: grid;
            grid-template-areas: 'divToolbarLeft divPdf divToolbarRigh';
        }
    </style>
</head>
<body>
    <h1>locki.pro Test</h1>
    <div>
        <label>Pagina:</label>
        <select class="pages" name="pages" id="pagesSelect"></select>
    </div>
    <div id="Container">
        <div id="divToolbarLeft">
            <button id="addObject">Agregar objeto</button>
            <div id="divReferenceToolbarLeft"></div>
        </div>

        <div id="divPdf" style="position: relative;">
            <div id="divCanvas" style="position: absolute; top: 0; left: 0;">
                <canvas id="the-canvas"></canvas>
            </div>
            <div id="containerKonva" style="position: absolute; top: 0; left: 0; z-index: 10;"></div>
        </div>

        <div id="divToolbarRight">
        </div>
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
        var scale = 1.5;
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
        var rect = null;

        function AddObjectDraggeable() {
            rect = new Konva.Rect({
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

            rect.on('transformstart', function () {
                UpdateProperties();
                console.log('transform start');
            });

            rect.on('dragmove', function () {
                UpdateProperties();
                console.log('dragmove')
            });
            rect.on('transform', function () {
                UpdateProperties();
                console.log('transform');
            });

            rect.on('transformend', function () {
                UpdateProperties();
                console.log('transform end');
            });

            rect.on('mouseover', function () {
                document.body.style.cursor = 'pointer';
            });

            rect.on('mouseout', function () {
                document.body.style.cursor = 'default';
            });

            CreatePropertiesObjects();
            UpdateProperties();
        }
        document.getElementById('addObject').addEventListener('click', AddObjectDraggeable);

        //function for add a properties in the toolbar
        var idProperties = 1;
        function CreatePropertiesObjects() {
            //div for position x ************************************
            var divX = document.createElement('div');

            //content of divX
            var lblX = document.createTextNode('Posición x: ');
            divX.appendChild(lblX);

            var X = document.createElement('input');
            X.id = 'x' + idProperties;
            X.type = 'text';
            X.value = rect.x();
            divX.appendChild(X);

            //div for position y ***************************************
            var divY = document.createElement('div');

            //content of divY
            var lblY = document.createTextNode('Posición y: ');
            divY.appendChild(lblY);

            var Y = document.createElement('input');
            Y.id = 'y' + idProperties;
            Y.type = 'text';
            Y.value = rect.y();
            divY.appendChild(Y);

            //div for rotation *****************************************
            var divR = document.createElement('div');

            //content of divR
            var lblR = document.createTextNode('Rotación: ');
            divR.appendChild(lblR);

            var R = document.createElement('input');
            R.id = 'r' + idProperties;
            R.type = 'text';
            R.value = rect.rotation();
            divR.appendChild(R);

            //div for width *****************************************
            var divW = document.createElement('div');

            //content of divR
            var lblW = document.createTextNode('Ancho: ');
            divW.appendChild(lblW);

            var W = document.createElement('input');
            W.id = 'w' + idProperties;
            W.type = 'text';
            W.value = rect.width();
            divW.appendChild(W);

            //div for height *****************************************
            var divH = document.createElement('div');

            //content of divR
            var lblH = document.createTextNode('Alto: ');
            divH.appendChild(lblH);

            var H = document.createElement('input');
            H.id = 'h' + idProperties;
            H.type = 'text';
            H.value = rect.height();
            divH.appendChild(H);

            //div main
            var divMain = document.createElement('div');
            divMain.appendChild(divX);
            divMain.appendChild(divY);
            divMain.appendChild(divR);
            divMain.appendChild(divW);
            divMain.appendChild(divH);

            //add the div main before the reference div
            var parentDiv = document.getElementById('divReferenceToolbarLeft').parentNode;
            var referenceDiv = document.getElementById('divReferenceToolbarLeft');
            parentDiv.insertBefore(divMain, referenceDiv);

            idProperties++;
        }

        //update datas of object draggeable
        function UpdateProperties() {
            var X = document.getElementById('x1');
            X.value = rect.x();
            X.addEventListener('change', ChangeProperties);

            var Y = document.getElementById('y1');
            Y.value = rect.y();
            Y.addEventListener('change', ChangeProperties);

            var R = document.getElementById('r1');
            R.value = rect.rotation();
            R.addEventListener('change', ChangeProperties);

            var W = document.getElementById('w1');
            W.value = rect.width();
            W.addEventListener('change', ChangeProperties);

            var H = document.getElementById('h1');
            H.value = rect.height();
            H.addEventListener('change', ChangeProperties);
        }

        //function for set datas of object draggeable
        function ChangeProperties() {
            var X = document.getElementById('x1');
            rect.x(parseInt(X.value));
            
            var Y = document.getElementById('y1');
            rect.y(parseInt(Y.value));

            var R = document.getElementById('r1');
            rect.rotation(parseInt(R.value));

            var W = document.getElementById('w1');
            rect.width(parseInt(W.value));

            var H = document.getElementById('h1');
            rect.height(parseInt(H.value));
        }
    </script>
</body>
</html>
