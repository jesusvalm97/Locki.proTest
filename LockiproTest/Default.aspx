<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="LockiproTest.Default" %>

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
            <button id="addText">Agregar texto</button>
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
        //parent class for objects draggable
        class ObjectDraggable {
            constructor(id, x, y, fill, draggable) {
                this.id = id;
                this.x = x;
                this.y = y;
                this.fill = fill;
                this.draggable = draggable;
            }
        }

        //children class for TextDraggable
        class TextDraggable extends ObjectDraggable {
            constructor(id, x, y, fill, draggable, text, fontSize, fontFamily) {
                super(id, x, y, fill, draggable);
                this.id = id;
                this.x = x;
                this.y = y;
                this.fill = fill;
                this.draggable = draggable;
                this.text = text;
                this.fontSize = fontSize;
                this.fontFamily = fontFamily;
            }

            CreateText() {
                var text = new Konva.Text({
                    id: this.id,
                    x: this.x,
                    y: this.y,
                    text: this.text,
                    fontSize: this.fontSize,
                    fontFamily: this.fontFamily,
                    fill: this.fil,
                    name: 'text',
                    draggable: this.draggable,
                });

                return text;
            }

            CreatePropertiesForm() {
                //div for text ******************************************
                var divT = document.createElement('div');

                //content of divT
                var lblT = document.createTextNode('Texto: ');
                divT.appendChild(lblT);

                var T = document.createElement('input');
                T.id = 't' + this.id;
                T.type = 'text';
                T.value = this.text;
                divT.appendChild(T);

                //div for fontsize **************************************
                var divFS = document.createElement('div');

                //contetn of divFS
                var lblFS = document.createTextNode('Tamaño de letra: ');
                divFS.appendChild(lblFS);

                var FS = document.createElement('input');
                FS.id = 'fs' + this.id;
                FS.type = 'text';
                FS.value = this.fontSize;
                divFS.appendChild(FS);

                //div for font family **********************************
                var divFF = document.createElement('div');

                //content of divFF
                var lblFF = document.createTextNode('Fuente: ');
                divFF.appendChild(lblFF);

                var FF = document.createElement('select');
                FF.id = 'ff' + this.id;
                divFF.appendChild(FF);

                var FFCalibri = document.createElement('option');
                FFCalibri.text = this.fontFamily;
                FFCalibri.value = this.fontFamily;
                FF.add(FFCalibri);

                var FFArial = document.createElement('option');
                FFArial.text = 'Arial';
                FFArial.value = 'Arial';
                FF.add(FFArial);

                var FFSansSerif = document.createElement('option');
                FFSansSerif.text = 'Sans Serif';
                FFSansSerif.value = 'Sans Serif';
                FF.add(FFSansSerif);

                var FFHelvetica = document.createElement('option');
                FFHelvetica.text = 'Helvetica';
                FFHelvetica.value = 'Helvetica';
                FF.add(FFHelvetica);

                var FFGaramond = document.createElement('option');
                FFGaramond.text = 'Garamond';
                FFGaramond.value = 'Garamond';
                FF.add(FFGaramond);

                var FFBodoni = document.createElement('option');
                FFBodoni.text = 'Bodoni';
                FFBodoni.value = 'Bodoni';
                FF.add(FFBodoni);

                var FFRockwell = document.createElement('option');
                FFRockwell.text = 'Rockwell';
                FFRockwell.value = 'Rockwell';
                FF.add(FFRockwell);

                var FFTahoma = document.createElement('option');
                FFTahoma.text = 'Tahoma';
                FFTahoma.value = 'Tahoma';
                FF.add(FFTahoma);

                var FFTimesNewRoman = document.createElement('option');
                FFTimesNewRoman.text = 'Times New Roman';
                FFTimesNewRoman.value = 'Times New Roman';
                FF.add(FFTimesNewRoman);

                var FFVerdana = document.createElement('option');
                FFVerdana.text = 'Verdana';
                FFVerdana.value = 'Verdana';
                FF.add(FFVerdana);

                //div for font color ************************************
                var divFC = document.createElement('div');

                //content of divFC
                var lblFC = document.createTextNode('Color: ');
                divFC.appendChild(lblFC);

                var FC = document.createElement('input');
                FC.id = 'fc' + this.id;
                FC.type = 'color';
                FC.value = this.fill;
                divFC.appendChild(FC);

                //div for position x ************************************
                var divX = document.createElement('div');

                //content of divX
                var lblX = document.createTextNode('Posición x: ');
                divX.appendChild(lblX);

                var X = document.createElement('input');
                X.id = 'x' + this.id;
                X.type = 'text';
                X.value = this.x;
                divX.appendChild(X);

                //div for position y ***************************************
                var divY = document.createElement('div');

                //content of divY
                var lblY = document.createTextNode('Posición y: ');
                divY.appendChild(lblY);

                var Y = document.createElement('input');
                Y.id = 'y' + this.id;
                Y.type = 'text';
                Y.value = this.y;
                divY.appendChild(Y);

                //div for rotation *****************************************
                var divR = document.createElement('div');

                //content of divR
                var lblR = document.createTextNode('Rotación: ');
                divR.appendChild(lblR);

                var R = document.createElement('input');
                R.id = 'r' + this.id;
                R.type = 'text';
                R.value = this.rotation;
                divR.appendChild(R);

                //div for width *****************************************
                var divW = document.createElement('div');

                //content of divW
                var lblW = document.createTextNode('Ancho: ');
                divW.appendChild(lblW);

                var W = document.createElement('input');
                W.id = 'w' + this.id;
                W.type = 'text';
                W.value = this.width;
                divW.appendChild(W);

                //div for height *****************************************
                var divH = document.createElement('div');

                //content of divH
                var lblH = document.createTextNode('Alto: ');
                divH.appendChild(lblH);

                var H = document.createElement('input');
                H.id = 'h' + this.id;
                H.type = 'text';
                H.value = this.height;
                divH.appendChild(H);

                var line = document.createElement('hr');

                //div main
                var divMain = document.createElement('div');
                divMain.appendChild(divT);
                divMain.appendChild(divFS);
                divMain.appendChild(divFF);
                divMain.appendChild(divFC);
                divMain.appendChild(divX);
                divMain.appendChild(divY);
                divMain.appendChild(divR);
                divMain.appendChild(divW);
                divMain.appendChild(divH);
                divMain.appendChild(line);

                //add the div main before the reference div
                var parentDiv = document.getElementById('divReferenceToolbarLeft').parentNode;
                var referenceDiv = document.getElementById('divReferenceToolbarLeft');
                parentDiv.insertBefore(divMain, referenceDiv);
            }

            UpdatePropertiesForm() {
                var i;
                for (i = 0; i < textsDragg.length; i++) {
                    var T = document.getElementById('ttext' + (i + 1));
                    T.addEventListener('change', ChangePropertiesText);

                    var FS = document.getElementById('fstext' + (i + 1));
                    FS.addEventListener('change', ChangePropertiesText);

                    var FF = document.getElementById('fftext' + (i + 1));
                    FF.addEventListener('change', ChangePropertiesText);

                    var FC = document.getElementById('fctext' + (i + 1));
                    FC.addEventListener('change', ChangePropertiesText);

                    var X = document.getElementById('xtext' + (i + 1));
                    X.value = textsDragg[i].x();
                    X.addEventListener('change', ChangePropertiesText);

                    var Y = document.getElementById('ytext' + (i + 1));
                    Y.value = textsDragg[i].y();
                    Y.addEventListener('change', ChangePropertiesText);

                    var R = document.getElementById('rtext' + (i + 1));
                    R.value = textsDragg[i].rotation();
                    R.addEventListener('change', ChangePropertiesText);

                    var W = document.getElementById('wtext' + (i + 1));
                    W.value = textsDragg[i].width();
                    W.addEventListener('change', ChangePropertiesText);

                    var H = document.getElementById('htext' + (i + 1));
                    H.value = textsDragg[i].height();
                    H.addEventListener('change', ChangePropertiesText);
                }
            }
        }

        //children class for RectDraggable
        class RectDraggable extends ObjectDraggable {
            constructor(id, x, y, width, height, fill, draggable) {
                super(id, x, y, fill, draggable);
                this.id = id;
                this.x = x;
                this.y = y;
                this.width = width;
                this.height = height;
                this.fill = fill;
                this.draggable = draggable;
            }

            CreateRect() {
                var rectangle = new Konva.Rect({
                    id: this.id,
                    x: this.x,
                    y: this.y,
                    width: this.width,
                    height: this.height,
                    fill: this.fill,
                    name: 'rect',
                    stroke: 'black',
                    draggable: this.draggable,
                });

                return rectangle;
            }

            CreatePropertiesForm() {
                //div for position x ************************************
                var divX = document.createElement('div');

                //content of divX
                var lblX = document.createTextNode('Posición x: ');
                divX.appendChild(lblX);

                var X = document.createElement('input');
                X.id = 'x' + this.id;
                X.type = 'text';
                X.value = this.x;
                divX.appendChild(X);

                //div for position y ***************************************
                var divY = document.createElement('div');

                //content of divY
                var lblY = document.createTextNode('Posición y: ');
                divY.appendChild(lblY);

                var Y = document.createElement('input');
                Y.id = 'y' + this.id;
                Y.type = 'text';
                Y.value = this.y;
                divY.appendChild(Y);

                //div for rotation *****************************************
                var divR = document.createElement('div');

                //content of divR
                var lblR = document.createTextNode('Rotación: ');
                divR.appendChild(lblR);

                var R = document.createElement('input');
                R.id = 'r' + this.id;
                R.type = 'text';
                R.value = 0;
                divR.appendChild(R);

                //div for width *****************************************
                var divW = document.createElement('div');

                //content of divW
                var lblW = document.createTextNode('Ancho: ');
                divW.appendChild(lblW);

                var W = document.createElement('input');
                W.id = 'w' + this.id;
                W.type = 'text';
                W.value = this.width;
                divW.appendChild(W);

                //div for height *****************************************
                var divH = document.createElement('div');

                //content of divH
                var lblH = document.createTextNode('Alto: ');
                divH.appendChild(lblH);

                var H = document.createElement('input');
                H.id = 'h' + this.id;
                H.type = 'text';
                H.value = this.height;
                divH.appendChild(H);

                var line = document.createElement('hr');

                //div main
                var divMain = document.createElement('div');
                divMain.appendChild(divX);
                divMain.appendChild(divY);
                divMain.appendChild(divR);
                divMain.appendChild(divW);
                divMain.appendChild(divH);
                divMain.appendChild(line);

                //add the div main before the reference div
                var parentDiv = document.getElementById('divReferenceToolbarLeft').parentNode;
                var referenceDiv = document.getElementById('divReferenceToolbarLeft');
                parentDiv.insertBefore(divMain, referenceDiv);
            }

            UpdatePropertiesForm() {
                var i;
                for (i = 0; i < objectsDragg.length; i++) {
                    var X = document.getElementById('x' + objectsDragg[i].id());
                    X.value = objectsDragg[i].x();
                    X.addEventListener('change', ChangePropertiesRectangle);

                    var Y = document.getElementById('y' + objectsDragg[i].id());
                    Y.value = objectsDragg[i].y();
                    Y.addEventListener('change', ChangePropertiesRectangle);

                    var R = document.getElementById('r' + objectsDragg[i].id());
                    R.value = objectsDragg[i].rotation();
                    R.addEventListener('change', ChangePropertiesRectangle);

                    var W = document.getElementById('w' + objectsDragg[i].id());
                    W.value = objectsDragg[i].width();
                    W.addEventListener('change', ChangePropertiesRectangle);

                    var H = document.getElementById('h' + objectsDragg[i].id());
                    H.value = objectsDragg[i].height();
                    H.addEventListener('change', ChangePropertiesRectangle);
                }
            }
        }

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

        //function for add a text draggeable
        var idTextDraggeable = 1;
        var text = null;

        function AddTextDraggable() {
            //create the Konva.Text
            var textDraggable = new TextDraggable('text' + idTextDraggeable, 10, 15, 'black', true, 'Lorem ipsum', 30, 'Calibri', true);

            text = textDraggable.CreateText();

            layer.add(text);
            textsDragg.push(text);

            //create new transformer
            var transformer = new Konva.Transformer();
            layer.add(transformer);
            transformer.nodes([text]);
            layer.draw();

            text.on('transformstart', function () {
                textDraggable.UpdatePropertiesForm();
                console.log('transform start');
            });

            text.on('dragmove', function () {
                textDraggable.UpdatePropertiesForm();
                console.log('dragmove')
            });
            text.on('transform', function () {
                textDraggable.UpdatePropertiesForm();
                console.log('transform');
            });

            text.on('transformend', function () {
                textDraggable.UpdatePropertiesForm();
                console.log('transform end');
            });

            text.on('mouseover', function () {
                document.body.style.cursor = 'pointer';
            });

            text.on('mouseout', function () {
                document.body.style.cursor = 'default';
            });

            textDraggable.CreatePropertiesForm();
            idTextDraggeable++;
        }
        document.getElementById('addText').addEventListener('click', AddTextDraggable);

        //function for set datas of text draggable
        function ChangePropertiesText() {
            var i;
            for (i = 0; i < textsDragg.length; i++) {
                var T = document.getElementById('ttext' + (i + 1));
                textsDragg[i].text(T.value);

                var FS = document.getElementById('fstext' + (i + 1));
                textsDragg[i].fontSize(parseInt(FS.value));

                var FF = document.getElementById('fftext' + (i + 1));
                textsDragg[i].fontFamily(FF.value);
                console.log(textsDragg[i].fontFamily());

                var FC = document.getElementById('fctext' + (i + 1));
                textsDragg[i].fill(FC.value);

                var X = document.getElementById('xtext' + (i + 1));
                textsDragg[i].x(parseInt(X.value));

                var Y = document.getElementById('ytext' + (i + 1));
                textsDragg[i].y(parseInt(Y.value));

                var R = document.getElementById('rtext' + (i + 1));
                textsDragg[i].rotation(parseInt(R.value));

                var W = document.getElementById('wtext' + (i + 1));
                textsDragg[i].width(parseInt(W.value));

                var H = document.getElementById('htext' + (i + 1));
                textsDragg[i].height(parseInt(H.value));
            }
        }

        //function for add a objects draggeables
        var idObjectDrag = 1;
        var rect = null;

        function AddRectDraggeable() {
            var rectangle = new RectDraggable('rect' + idObjectDrag, 160, 60, 100, 90, 'white', true);
            rect = rectangle.CreateRect();
            layer.add(rect);

            //create new transformer
            var transformer = new Konva.Transformer();
            layer.add(transformer);
            transformer.nodes([rect]);
            layer.draw();

            objectsDragg.push(rect);
            idObjectDrag++;

            var i;
            for (i = 0; i < objectsDragg.length; i++) {
                if (objectsDragg[i].id == rect.id) {
                    rect.on('transformstart', function () {
                        rectangle.UpdatePropertiesForm();
                        console.log('transform start');
                    });

                    rect.on('dragmove', function () {
                        rectangle.UpdatePropertiesForm();
                        console.log('dragmove')
                    });
                    rect.on('transform', function () {
                        rectangle.UpdatePropertiesForm();
                        console.log('transform');
                    });

                    rect.on('transformend', function () {
                        rectangle.UpdatePropertiesForm();
                        console.log('transform end');
                    });

                    rect.on('mouseover', function () {
                        document.body.style.cursor = 'pointer';
                    });

                    rect.on('mouseout', function () {
                        document.body.style.cursor = 'default';
                    });
                }
            }

            rectangle.CreatePropertiesForm();
        }
        document.getElementById('addObject').addEventListener('click', AddRectDraggeable);

        //function for set datas of object draggeable
        function ChangePropertiesRectangle() {
            var i;
            for (i = 0; i < objectsDragg.length; i++) {
                var X = document.getElementById('x' + objectsDragg[i].id());
                objectsDragg[i].x(parseInt(X.value));

                var Y = document.getElementById('y' + objectsDragg[i].id());
                objectsDragg[i].y(parseInt(Y.value));

                var R = document.getElementById('r' + objectsDragg[i].id());
                objectsDragg[i].rotation(parseInt(R.value));

                var W = document.getElementById('w' + objectsDragg[i].id());
                objectsDragg[i].width(parseInt(W.value));

                var H = document.getElementById('h' + objectsDragg[i].id());
                objectsDragg[i].height(parseInt(H.value));
            }
        }
    </script>
</body>
</html>
