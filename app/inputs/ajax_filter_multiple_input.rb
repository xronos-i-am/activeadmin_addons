class AjaxFilterMultipleInput < Formtastic::Inputs::SelectInput

  include ActiveAdmin::Inputs::Filters::Base

  def input_html_options
    opts = {}
    opts[:class] = ['select2-ajax'].concat([@options[:class]] || []).join(' ')
    opts["data-fields"] = (@options[:fields] || []).to_json
    opts["data-url"] = url
    opts["data-response_root"] = @options[:response_root] || @options[:url].to_s.split('/').last
    opts["data-display_name"] = @options[:display_name] || "name"
    opts["data-minimum_input_length"] = @options[:minimum_input_length] || 1
    opts["data-width"] = @options[:width] || "100%"
    opts["data-order"] = @options[:order_by] if @options[:order_by]
    opts["data-per_page"] = @options[:per_page] if @options[:per_page]
    opts["data-multiple"] = 'true'

    super.merge opts
  end

  def collection
    display_name = @options[:display_name] || "name"

    filter_class = (@options[:search_class] || method.to_s.chomp("_in").chomp("_id")).classify.constantize
    selected_value = @object.conditions.find {|c| c.attributes.map(&:name).include? method.to_s.chomp('_in')}.values.map(&:value) rescue nil
    unless selected_value.blank?
      # data = filter_class.select([:id] | @options[:fields].to_a).where(id: selected_value)
      data = filter_class.where(id: selected_value)
      data = data.map {|i| [i.send(display_name.to_sym), i.id]}
    else
      []
    end

  end

  def url
    if @options[:url].is_a?(Proc)
      template.instance_eval(&@options[:url]) || ""
    else
      @options[:url] || ""
    end
  end
end
