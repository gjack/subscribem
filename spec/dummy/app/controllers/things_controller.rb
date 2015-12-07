class ThingsController < ApplicationController
  def index
    #@things = current_account.things
    @things = Thing.all
  end
end
