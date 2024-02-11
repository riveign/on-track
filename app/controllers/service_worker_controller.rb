class ServiceWorkerController < ApplicationController
  def service_worker
    render file: 'app/assets/javascripts/service_worker.js', content_type: 'application/javascript'
  end

  def manifest
    render file: 'app/assets/javascripts/manifest.json'
  end
end
