class PunchesController < ApplicationController
  # GET /punches
  # GET /punches.xml
  def index
    @punches = Punch.all
    @punch = Punch.new

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @punches }
    end
  end

  # GET /punches/1
  # GET /punches/1.xml
  def show
    @punch = Punch.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @punch }
    end
  end

  # GET /punches/new
  # GET /punches/new.xml
  def new
    @punch = Punch.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @punch }
    end
  end

  # GET /punches/1/edit
  def edit
    @punch = Punch.find(params[:id])
  end

  # POST /punches
  # POST /punches.xml
  def create
    @punch = Punch.new(params[:punch])

    respond_to do |format|
      if @punch.parse_and_save
        format.html { redirect_to(punches_path, :notice => 'Punch was successfully created.') }
        format.xml  { render :xml => @punch, :status => :created, :location => @punch }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @punch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /punches/1
  # PUT /punches/1.xml
  def update
    @punch = Punch.find(params[:id])
    @punch.attributes = params[:punch]

    respond_to do |format|
      if @punch.parse_and_save
        format.html { redirect_to(punches_path, :notice => 'Punch was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @punch.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /punches/1
  # DELETE /punches/1.xml
  def destroy
    @punch = Punch.find(params[:id])
    @punch.destroy

    respond_to do |format|
      format.html { redirect_to(punches_url) }
      format.xml  { head :ok }
    end
  end
  
  #this is the json function for the autocomplete
  def autocomplete
  	@tags = nil
  	unless params[:term].blank?
  		case params[:term].first
		when "\#"
			term = params[:term].gsub("\#", "")
			@tags = Punch.project_counts.where("tags.name like ?", "%#{term}%").collect! {|p| "\#" + p.name}
		when "@"
			term = params[:term].gsub("@", "")
			@tags = Punch.client_counts.where("tags.name like ?", "%#{term}%").collect! {|c| "@" + c.name}
		when "*"
			term = params[:term].gsub("*", "")
			@tags = Punch.action_counts.where("tags.name like ?", "%#{term}%").collect! {|a| "*" + a.name}
		else
			term = params[:term]
	  	@tags = Punch.project_counts.where("tags.name like ?", "%#{term}%").collect! {|p| "\#" + p.name}
	  	@tags << Punch.action_counts.where("tags.name like ?", "%#{term}%").collect! {|a| "*" + a.name}
	  	@tags << Punch.client_counts.where("tags.name like ?", "%#{term}%").collect! {|c| "@" + c.name}
  		end
  		@tags.flatten!
  	end
  	respond_to do |format|
  		format.json { render :json => @tags}
  	end
  end
end
