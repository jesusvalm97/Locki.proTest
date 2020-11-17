<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="LockiproTest.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>PDF Viewer</title>
    <script src="https://mozilla.github.io/pdf.js/build/pdf.js"></script>
</head>
<body>
    <h1>PDF.js Test</h1>
    <div>
        <label>Pagina:</label>
        <select name="pages" id="pagesSelect">

        </select>
    </div>
    <div id="divCanvas">
        <canvas id="the-canvas"></canvas>
    </div>
    
    <script>
        // If absolute URL from the remote server is provided, configure the CORS
        // header on that server.
        var url = 'https://raw.githubusercontent.com/mozilla/pdf.js/ba2edeae/web/compressed.tracemonkey-pldi-09.pdf';

        // Loaded via <script> tag, create shortcut to access PDF.js exports.
        var pdfjsLib = window['pdfjs-dist/build/pdf'];

        // The workerSrc property shall be specified.
        pdfjsLib.GlobalWorkerOptions.workerSrc = '//mozilla.github.io/pdf.js/build/pdf.worker.js';


        var pdfDoc = null,
            scale = 2;
        var pagesSelect = document.getElementById('pagesSelect');

        //functino for get the pdf
        pdfjsLib.getDocument(url).promise.then(function (pdfDoc_) {
            pdfDoc = pdfDoc_;

            var i;
            for (i = 1; i <= pdfDoc.numPages; i++) {
                RenderPage(i);

                var option = document.createElement('option');
                option.text = i;
                pagesSelect.add(option);
            }
        });

        //function for render page in the canvas
        function RenderPage(num) {
            // Using promise to fetch the page
            pdfDoc.getPage(num).then(function (page) {
                var viewport = page.getViewport({ scale: scale });
                //create new canvas
                var newCanvas = document.createElement('canvas');
                newCanvas.height = viewport.height;
                newCanvas.width = viewport.width;

                //render pdf page into canvas context
                var context = newCanvas.getContext('2d');
                var renderContext = {
                    canvasContext: context,
                    viewport: viewport
                }
                var renderTask = page.render(renderContext);
                renderTask.promise.then(function () {
                    console.log('Page rendered');
                });

                //create div for number page
                var newDivNumPage = document.createElement('div');

                //crete text with number page
                var numPage = document.createTextNode(num);
                newDivNumPage.appendChild(numPage);

                //create a new div
                var newDivCanvas = document.createElement('div');

                //add the new canvas in the new div
                newDivCanvas.appendChild(newCanvas);

                //create div main
                var newDivMain = document.createElement('div');
                newDivMain.appendChild(newDivNumPage);
                newDivMain.appendChild(newDivCanvas);

                //add the new div before the originalDiv
                var currentDiv = document.getElementById('divCanvas');
                document.body.insertBefore(newDivMain, currentDiv);
            });
        }
    </script>
</body>
</html>
