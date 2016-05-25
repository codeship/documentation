// Embedded discourse comments iframe
function comments (){
var includeURL = window.location.protocol + "//" + window.location.host + "/" + window.location.pathname;

DiscourseEmbed = { discourseUrl: 'https://community.codeship.com/',
                   discourseEmbedUrl: includeURL };

(function() {
  var d = document.createElement('script'); d.type = 'text/javascript'; d.async = true;
  d.src = DiscourseEmbed.discourseUrl + 'javascripts/embed.js';
  (document.getElementsByTagName('head')[0] || document.getElementsByTagName('body')[0]).appendChild(d);
})();
}
