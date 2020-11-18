<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="LockiproTest.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title>PDF Viewer</title>
    <script src="https://mozilla.github.io/pdf.js/build/pdf.js"></script>
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

    </script>
</body>
</html>
