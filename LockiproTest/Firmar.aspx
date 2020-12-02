<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Firmar.aspx.cs" Inherits="LockiproTest.Firmar" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
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
            <input type="hidden" id="hiddenText" />
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
                <h3>Campos de firma</h3>
                <button id="btnFirmar">Firmar</button>
                <input type="text" id="txtSignSelected" placeholder="Campo seleccionado" disabled />
                <div id="divReferenceSigners"></div>

                <h3>Campos de Texto</h3>
                <div id="divReferenceText"></div>

            </div>
        </div>
    </div>

    <script>
        //parent class for objects draggable
        class ObjectDraggable {
            constructor(id, x, y, fill, draggable, page) {
                this.id = id;
                this.x = x;
                this.y = y;
                this.fill = fill;
                this.draggable = draggable;
                this.page = page;
            }
        }

        //children class for TextDraggable
        class TextDraggable extends ObjectDraggable {
            constructor(id, x, y, fill, draggable, page, text, fontSize, fontFamily, stroke) {
                super(id, x, y, fill, draggable, page);
                this.id = id;
                this.x = x;
                this.y = y;
                this.fill = fill;
                this.draggable = draggable;
                this.page = page;
                this.text = text;
                this.fontSize = fontSize;
                this.fontFamily = fontFamily;
                this.stroke = stroke;
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
                    name: this.page,
                    draggable: this.draggable,
                    stroke: this.stroke,
                    strokeWidth: 1,
                });

                return text;
            }

            CreatePropertiesForm() {
                //div for id ************************************
                var divId = document.createElement('div');

                //content of divX
                var lblId = document.createTextNode('Identificador: ');
                divId.appendChild(lblId);

                var Id = document.createElement('input');
                Id.id = 'id' + this.id;
                Id.type = 'text';
                Id.value = this.id;
                Id.disabled = true;
                Id.className = "inputFormProperties";
                divId.appendChild(Id);

                //div for text ******************************************
                var divT = document.createElement('div');

                //content of divT
                var lblT = document.createTextNode('Nombre: ');
                divT.appendChild(lblT);

                var T = document.createElement('input');
                T.id = 't' + this.id;
                T.type = 'text';
                T.value = this.text;
                T.className = "inputFormProperties";
                T.addEventListener('change', ChangePropertiesText);
                divT.appendChild(T);

                var line = document.createElement('hr');

                //div main
                var divMain = document.createElement('div');
                divMain.id = 'divMain' + this.id;
                divMain.appendChild(divId);
                divMain.appendChild(divT);
                divMain.appendChild(line);

                //parent for divMain
                var parent = document.createElement('div');
                parent.appendChild(divMain);

                var parentDiv = document.getElementById('divReferenceText');
                parentDiv.appendChild(parent);
            }
        }

        var idDivSigner = 1;
        //children class for RectDraggable
        class RectDraggable extends ObjectDraggable {
            constructor(id, x, y, width, height, fill, draggable, page, stroke) {
                super(id, x, y, fill, draggable, page);
                this.id = id;
                this.x = x;
                this.y = y;
                this.width = width;
                this.height = height;
                this.fill = fill;
                this.draggable = draggable;
                this.page = page;
                this.stroke = stroke;
            }

            CreateRect() {
                var rectangle = new Konva.Rect({
                    id: this.id,
                    x: this.x,
                    y: this.y,
                    width: this.width,
                    height: this.height,
                    fill: this.fill,
                    name: this.page,
                    stroke: this.stroke,
                    draggable: this.draggable,
                });

                return rectangle;
            }

            CreateImage() {
                var imageObj = new Image();

                var firma = new Konva.Image({
                    id: this.id,
                    x: this.x,
                    y: this.y,
                    width: this.width,
                    height: this.height,
                    name: this.page,
                    stroke: this.stroke,
                    draggable: false,
                    image: imageObj,
                });
                
                imageObj.src = 'https://www.consumer.es/wp-content/uploads/2019/07/img_firma-3-300x196.jpg';

                return firma;
            }

            CreatePropertiesForm() {
                //div for position x ************************************
                var divId = document.createElement('div');

                //content of divX
                var lblId = document.createTextNode('Identificador: ');
                divId.appendChild(lblId);

                var Id = document.createElement('input');
                Id.id = 'id' + this.id;
                Id.type = 'text';
                Id.value = this.id;
                Id.disabled = true;
                Id.className = "inputFormProperties";
                divId.appendChild(Id);

                var line = document.createElement('hr');

                //div main
                var divMain = document.createElement('div');
                divMain.id = 'divMain' + this.id;
                divMain.appendChild(divId);
                divMain.appendChild(line);

                //parent for divMain
                var parent = document.createElement('div');
                parent.appendChild(divMain);

                var parentDiv = document.getElementById('divReferenceSigners');
                parentDiv.appendChild(parent);
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

            AddSign();

            AddText();

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
            Save();

            //remove objects draggables
            layer.removeChildren();

            //remove properties form
            CleanPropertiesForm();

            //render the next page
            RenderPage(parseInt(currentPage));
            console.log('pagina ' + currentPage);

            //add existing object
            AddExistingObjects(currentPage);

            //call method draw from layer for if don't exist an objects update the layer
            layer.draw();
        }
        //assign the function ChangePage to the select
        pagesSelect.addEventListener('change', ChangePage);

        //function for add existing objects
        function AddExistingObjects(page) {
            //add exisitng rects
            for (var i = 0; i < objectsDragg.length; i++) {
                if (objectsDragg[i].name() == page) {
                    var rectangle = new RectDraggable(objectsDragg[i].id(), objectsDragg[i].x(), objectsDragg[i].y(), objectsDragg[i].width(), objectsDragg[i].height(), objectsDragg[i].fill(), objectsDragg[i].draggable(), objectsDragg[i].name(), objectsDragg[i].stroke());
                    rect = rectangle.CreateImage();
                    layer.add(rect);

                    //change the object for made the match with the properties form
                    objectsDragg[i] = rect;

                    layer.draw();

                    rect.on('transformstart', function (e) {
                        console.log('transform start');
                    });

                    rect.on('dragmove', function (e) {
                        console.log('dragmove')
                    });
                    rect.on('transform', function (e) {
                        console.log('transform');
                    });

                    rect.on('transformend', function (e) {
                        console.log('transform end');
                    });

                    rect.on('mouseover', function (e) {
                        document.getElementById('txtSignSelected').value = e.target.id();
                        document.body.style.cursor = 'pointer';
                    });

                    rect.on('mouseout', function () {
                        document.body.style.cursor = 'default';
                    });

                    rect.on('click', function (e) {
                        document.getElementById('txtSignSelected').value = e.target.id();
                    });

                    rectangle.CreatePropertiesForm();
                }
            }

            //add existing texts
            for (var j = 0; j < textsDragg.length; j++) {
                if (textsDragg[j].name() == page) {
                    //create the Konva.Text
                    var textDraggable = new TextDraggable(textsDragg[j].id(), textsDragg[j].x(), textsDragg[j].y(), textsDragg[j].fill(), textsDragg[j].draggable(), textsDragg[j].name(), textsDragg[j].text(), textsDragg[j].fontSize(), textsDragg[j].fontFamily(), textsDragg[j].stroke());
                    text = textDraggable.CreateText();
                    layer.add(text);

                    //change the object for made the match with the properties form
                    textsDragg[j] = text;

                    layer.draw();

                    text.on('transformstart', function (e) {
                        console.log('transform start');
                    });

                    text.on('dragmove', function (e) {
                        console.log('dragmove')
                    });
                    text.on('transform', function (e) {
                        console.log('transform');
                    });

                    text.on('transformend', function (e) {
                        console.log('transform end');
                    });

                    text.on('mouseover', function (e) {
                        document.getElementById('txtSignSelected').value = e.target.id();
                        document.body.style.cursor = 'pointer';
                    });

                    text.on('mouseout', function () {
                        document.body.style.cursor = 'default';
                    });

                    text.on('click', function (e) {
                        document.getElementById('txtSignSelected').value = e.target.id();
                    });

                    textDraggable.CreatePropertiesForm();
                }
            }
        }

        //function for add a objects draggeables
        var idRectDragg = 1;
        var rect = null;

        function AddSign() {
            var rectangle = new RectDraggable('firma' + idRectDragg, 160, 60, 100, 90, 'white', false, '1', 'black');
            rect = rectangle.CreateRect();
            layer.add(rect);
            layer.draw();

            objectsDragg.push(rect);
            idRectDragg++;

            var i;
            for (i = 0; i < objectsDragg.length; i++) {
                if (objectsDragg[i].id == rect.id) {
                    rect.on('transformstart', function (e) {
                        console.log('transform start');
                    });

                    rect.on('dragmove', function (e) {
                        console.log('dragmove')
                    });
                    rect.on('transform', function (e) {
                        console.log('transform');
                    });

                    rect.on('transformend', function (e) {
                        console.log('transform end');
                    });

                    rect.on('mouseover', function (e) {
                        document.getElementById('txtSignSelected').value = e.target.id();
                        document.body.style.cursor = 'pointer';
                    });

                    rect.on('mouseout', function () {
                        document.body.style.cursor = 'default';
                    });

                    rect.on('click', function (e) {
                        document.getElementById('txtSignSelected').value = e.target.id();
                    });
                }
            }

            rectangle.CreatePropertiesForm();
        }

        //function for sign
        function Sign() {
            for (var i = 0; i < objectsDragg.length; i++) {
                if (document.getElementById('txtSignSelected').value == objectsDragg[i].id()) {
                    //var rectangle = new RectDraggable('rect' + idRectDragg, 160, 60, 100, 90, 'white', false, currentPage, 'black');
                    var rectangle = new RectDraggable(objectsDragg[i].id(), objectsDragg[i].x(), objectsDragg[i].y(), objectsDragg[i].width(), objectsDragg[i].height(), objectsDragg[i].fill(), objectsDragg[i].draggable(), objectsDragg[i].name(), objectsDragg[i].stroke());
                    image = rectangle.CreateImage();
                    DeleteSpecificObject(objectsDragg[i].id());
                    layer.add(image);
                    objectsDragg[i] = image;
                    rectangle.CreatePropertiesForm();
                }
            }

            layer.draw();
        }
        document.getElementById('btnFirmar').addEventListener('click', Sign);

        //function for add text
        var idTextDraggeable = 1;
        var text = null;
        function AddText() {
            //create the Konva.Text
            var textDraggable = new TextDraggable('text' + idTextDraggeable, 10, 15, 'black', false, '1', 'Nombre Completo', 30, 'Calibri', 'black');
            text = textDraggable.CreateText();
            layer.add(text);
            layer.draw();

            textsDragg.push(text);
            idTextDraggeable++;
            
            text.on('transformstart', function (e) {
                console.log('transform start');
            });

            text.on('dragmove', function (e) {
                console.log('dragmove')
            });
            text.on('transform', function (e) {
                console.log('transform');
            });

            text.on('transformend', function (e) {
                console.log('transform end');
            });

            text.on('mouseover', function (e) {
                document.getElementById('txtSignSelected').value = e.target.id();
                document.body.style.cursor = 'pointer';
            });

            text.on('mouseout', function () {
                document.body.style.cursor = 'default';
            });

            text.on('click', function (e) {
                document.getElementById('txtSignSelected').value = e.target.id();
            });

            textDraggable.CreatePropertiesForm();
        }

        //function for set datas of text draggable
        function ChangePropertiesText() {
            var i;
            for (i = 0; i < textsDragg.length; i++) {
                var T = document.getElementById('ttext' + (i + 1));
                textsDragg[i].text(T.value);

                layer.draw();
            }
        }

        //function for delete an object
        function Delete() {
            //delete rect
            for (var i = 0; i < objectsDragg.length; i++) {
                if (objectsDragg[i].id() == document.getElementById('txtDelete').value) {
                    var transformer = layer.find('Transformer').toArray();

                    for (var x = 0; x < transformer.length; x++) {
                        var nodes = transformer[x].nodes();

                        for (var y = 0; y < nodes.length; y++) {

                            if (nodes[y].id() == document.getElementById('txtDelete').value) {
                                //remove the object
                                nodes[y].remove();
                                //destroy the transform of the node
                                transformer[x].destroy();
                                //clean the properties form
                                CleanSpecificPropertyForm(objectsDragg[i].id());
                                //remove the object from the array
                                objectsDragg.splice(i, 1);
                                //update the layer
                                layer.draw();
                            }
                        }
                    }
                }
            }

            //delete text
            for (var j = 0; j < textsDragg.length; j++) {
                if (textsDragg[j].id() == document.getElementById('txtDelete').value) {
                    var transformer = layer.find('Transformer').toArray();

                    for (var x = 0; x < transformer.length; x++) {
                        var nodes = transformer[x].nodes();

                        for (var y = 0; y < nodes.length; y++) {

                            if (nodes[y].id() == document.getElementById('txtDelete').value) {
                                //remove the object
                                nodes[y].remove();
                                //destroy the transform of the node
                                transformer[x].destroy();
                                //clean the properties form
                                CleanSpecificPropertyForm(textsDragg[j].id());
                                //remove the object from the array
                                textsDragg.splice(j, 1);
                                //update the layer
                                layer.draw();
                            }
                        }
                    }
                }
            }
        }

        function DeleteSpecificObject(idObject) {
            //delete rect
            for (var i = 0; i < objectsDragg.length; i++) {
                if (objectsDragg[i].id() == idObject) {

                    var rects = layer.find('Rect').toArray();

                    for (var x = 0; x < rects.length; x++) {
                        if (rects[x].id() == idObject) {
                            //remove node form layer
                            rects[x].remove();
                            //clean the properties form
                            CleanSpecificPropertyForm(objectsDragg[i].id());
                            //remove the object from the array
                            objectsDragg.splice(i, 1);
                            //update the layer
                            layer.draw();
                        }
                    }
                }
            }
        }

        //clean all properties form
        function CleanPropertiesForm() {
            for (var i = 0; i <= objectsDragg.length; i++) {
                if (document.getElementById('divMainfirma' + (i + 1)) != null) {
                    var parentDivMain = document.getElementById('divMainfirma' + (i + 1)).parentNode;
                    parentDivMain.innerHTML = '';
                }
            }

            for (var i = 0; i <= textsDragg.length; i++) {
                if (document.getElementById('divMaintext' + (i + 1)) != null) {
                    var parentDivMain = document.getElementById('divMaintext' + (i + 1)).parentNode;
                    parentDivMain.innerHTML = '';
                }
            }
        }

        //clean specific property form
        function CleanSpecificPropertyForm(idObject) {
            var parentDivMain = document.getElementById('divMain' + idObject).parentNode;
            parentDivMain.innerHTML = '';
        }

        //function for save the datas of objects
        function Save() {
            var j;
            for (j = 0; j < textsDragg.length; j++) {
                if (textsDragg[j].id() == 'text' + (j + 1) && textsDragg[j].name() == ancientPage) {
                    var T = document.getElementById('ttext' + (j + 1));
                    textsDragg[j].text(T.value);

                    console.log('Se guardaron los datos de ' + textsDragg[j].id());
                }
            }

            layer.draw();
        }
        document.getElementById('save').addEventListener('click', Save);
    </script>
</body>
</html>
