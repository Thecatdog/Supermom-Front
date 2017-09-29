class MeetingsController < ApplicationController
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]
  
  def get_location_info
    Meeting.new
    
    require 'rubygems'
    require 'mechanize'
    require 'rest-client'

    search_arr = ['축제', '베이비페어']

    search_arr.each do | search |
      agent = Mechanize.new
      page = agent.get "http://naver.com"
      search_form = page.form_with :name => "sform"
      search_form.field_with(:name=>"query").value = search
      search_results = agent.submit search_form
      main_uri = search_results.uri

      html = agent.get(main_uri).body
      html_doc = Nokogiri::HTML(html)
      
      html_doc.css('span.tit_box').css('span.date').each do |t|
          puts t.text.slice!(0...10)
        end 

        if search.eql?('축제')
          html_doc.css('h5').each do |t|
            puts t.text
          end
      else
        html_doc.css('h6').each do |t|
            puts t.text
          end
      end
    end

     
end

  # GET /meetings
  # GET /meetings.json
  def index
    @meetings = Meeting.all
  end

  # GET /meetings/1
  # GET /meetings/1.json
  def show
  end

  # GET /meetings/new
  def new
    @meeting = Meeting.new
  end

  # GET /meetings/1/edit
  def edit
  end

  # POST /meetings
  # POST /meetings.json
  def create
    @meeting = Meeting.new(meeting_params)

    respond_to do |format|
       if @meeting.save
        # format.html { redirect_to @meeting, notice: 'Meeting was successfully created.' }
        # format.json { render :index, status: :created, location: @meeting }
        format.html { redirect_to meetings_url}
        format.json { head :no_content }
      else
        format.html { render :new }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /meetings/1
  # PATCH/PUT /meetings/1.json
  def update
    respond_to do |format|
      if @meeting.update(meeting_params)
        # format.html { redirect_to @meeting, notice: 'Meeting was successfully updated.' }
        # format.json { render :show, status: :ok, location: @meeting }
        format.html { redirect_to meetings_url, notice: @meeting.start_time.in_time_zone("Asia/Seoul").strftime("%F")+' 이벤트가 성공적으로 갱신되었습니다.' }
        format.json { head :no_content }
      else
        format.html { render :edit }
        format.json { render json: @meeting.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /meetings/1
  # DELETE /meetings/1.json
  def destroy
    @meeting.destroy
    respond_to do |format|
      format.html { redirect_to meetings_url }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_meeting
      @meeting = Meeting.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def meeting_params
      params.require(:meeting).permit(:name, :start_time)
    end
end