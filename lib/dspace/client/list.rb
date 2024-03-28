# frozen_string_literal: true

module DSpace
  class List
    attr_reader :data, :page, :size, :total_elements, :total_pages, :next_page, :prev_page, :last_page

    def self.from_response(client, response, key:, type:)
      body = response.body
      data = body.dig("_embedded", key) || []
      new(
        data: data.map { |attrs| type.new(client, attrs) },
        page: body.dig("page", "number"),
        size: body.dig("page", "size"),
        total_elements: body.dig("page", "totalElements"),
        total_pages: body.dig("page", "totalPages")
      )
    end

    def self.from_search_response(client, response)
      body = response.body
      data = body.dig("_embedded", "searchResult", "_embedded", "objects") || []
      new(
        data: data.map { |attrs| resolve_indexable_type(client, attrs) },
        page: body.dig("_embedded", "searchResult", "page", "number"),
        size: body.dig("_embedded", "searchResult", "page", "size"),
        total_elements: body.dig("_embedded", "searchResult", "page", "totalElements"),
        total_pages: body.dig("_embedded", "searchResult", "page", "totalPages")
      )
    end

    def initialize(data:, page:, size:, total_elements:, total_pages:)
      @data = data
      @page = page
      @size = size
      @total_elements = total_elements
      @total_pages = total_pages
      @first_page = 0
      @next_page = resolve_next_page(page)
      @prev_page = resolve_prev_page(page)
      @last_page = resolve_last_page(total_pages)
    end

    def resolve_next_page(page)
      (page + 1 <= resolve_last_page(total_pages)) ? (page + 1) : nil
    end

    def resolve_prev_page(page)
      (page - 1 >= 0) ? (page - 1) : nil
    end

    def resolve_last_page(total)
      (total - 1 >= 0) ? (total - 1) : 0
    end

    def self.resolve_indexable_type(client, attrs)
      data = attrs.dig("_embedded", "indexableObject")
      Kernel.const_get("DSpace::#{data["type"].capitalize}").new(client, data)
    end
  end
end
