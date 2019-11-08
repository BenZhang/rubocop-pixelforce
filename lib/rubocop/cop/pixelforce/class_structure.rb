module RuboCop
  module Cop
    module Pixelforce
      class ClassStructure < Cop
        HUMANIZED_NODE_TYPE = {
          casgn: :constants,
          defs: :class_methods,
          def: :public_methods,
          sclass: :class_singleton
        }.freeze

        VISIBILITY_SCOPES = %i[private protected public].freeze
        MSG = '`%<category>s` is supposed to appear before ' \
              '`%<previous>s`.'

        def_node_matcher :visibility_block?, <<~PATTERN
          (send nil? { :private :protected :public })
        PATTERN

        # Validates code style on class declaration.
        # Add offense when find a node out of expected order.
        def on_class(class_node)
          previous = -1
          previous_category = nil
          previous_node_end_line = -1
          previous_method_name = nil
          walk_over_nested_class_definition(class_node) do |node, category|
            index = expected_order.index(category)
            if index < previous
              message = format(MSG, category: category,
                                    previous: expected_order[previous])
              add_offense(node, message: message)
            end
            previous = index

            next unless node.respond_to?(:method_name)
            if previous_category && category != previous_category && node.loc.first_line - previous_node_end_line < 2
              add_offense(node, message: "Use empty lines between categories.")
            end

            if previous_method_name && previous_method_name == node.method_name && node.loc.first_line - previous_node_end_line > 1
              add_offense(node, message: "Don't Use empty lines between same categories.")
            end
            previous_category = category
            previous_node_end_line = node.loc.last_line
            previous_method_name = node.method_name
          end
        end

        # Autocorrect by swapping between two nodes autocorrecting them
        def autocorrect(node)
          node_classification = classify(node)
          previous = left_siblings_of(node).find do |sibling|
            classification = classify(sibling)
            !ignore?(classification) && node_classification != classification
          end

          current_range = source_range_with_comment(node)
          previous_range = source_range_with_comment(previous)

          lambda do |corrector|
            corrector.insert_before(previous_range, current_range.source)
            corrector.remove(current_range)
          end
        end

        private

        # Classifies a node to match with something in the {expected_order}
        # @param node to be analysed
        # @return String when the node type is a `:block` then
        #   {classify} recursively with the first children
        # @return String when the node type is a `:send` then {find_category}
        #   by method name
        # @return String otherwise trying to {humanize_node} of the current node
        def classify(node)
          return node.to_s unless node.respond_to?(:type)

          case node.type
          when :block
            classify(node.send_node)
          when :send
            find_category(node)
          else
            humanize_node(node)
          end.to_s
        end

        # Categorize a node according to the {expected_order}
        # Try to match {categories} values against the node's method_name given
        # also its visibility.
        # @param node to be analysed.
        # @return [String] with the key category or the `method_name` as string
        def find_category(node)
          name = node.method_name.to_s
          category, = categories.find { |_, names| names.include?(name) }
          key = category || name
          visibility_key = "#{node_visibility(node)}_#{key}"
          expected_order.include?(visibility_key) ? visibility_key : key
        end

        def walk_over_nested_class_definition(class_node)
          class_elements(class_node).each do |node|
            classification = classify(node)
            next if ignore?(classification)

            yield node, classification
          end
        end

        def class_elements(class_node)
          class_def = class_node.body

          return [] unless class_def

          if class_def.def_type? || class_def.send_type?
            [class_def]
          else
            class_def.children.compact
          end
        end

        def ignore?(classification)
          classification.nil? ||
            classification.to_s.end_with?('=') ||
            expected_order.index(classification).nil?
        end

        def node_visibility(node)
          scope = find_visibility_start(node)
          scope&.method_name || :public
        end

        def find_visibility_start(node)
          left_siblings_of(node)
            .reverse
            .find(&method(:visibility_block?))
        end

        # Navigate to find the last protected method
        def find_visibility_end(node)
          possible_visibilities = VISIBILITY_SCOPES - [node_visibility(node)]
          right = right_siblings_of(node)
          right.find do |child_node|
            possible_visibilities.include?(node_visibility(child_node))
          end || right.last
        end

        def siblings_of(node)
          node.parent.children
        end

        def right_siblings_of(node)
          siblings_of(node)[node.sibling_index..-1]
        end

        def left_siblings_of(node)
          siblings_of(node)[0, node.sibling_index]
        end

        def humanize_node(node)
          if node.def_type?
            return :initializer if node.method?(:initialize)

            return "#{node_visibility(node)}_methods"
          end
          HUMANIZED_NODE_TYPE[node.type] || node.type
        end

        def source_range_with_comment(node)
          begin_pos, end_pos =
            if node.def_type?
              start_node = find_visibility_start(node) || node
              end_node = find_visibility_end(node) || node
              [begin_pos_with_comment(start_node),
               end_position_for(end_node) + 1]
            else
              [begin_pos_with_comment(node), end_position_for(node)]
            end

          Parser::Source::Range.new(buffer, begin_pos, end_pos)
        end

        def end_position_for(node)
          end_line = buffer.line_for_position(node.loc.expression.end_pos)
          buffer.line_range(end_line).end_pos
        end

        def begin_pos_with_comment(node)
          annotation_line = node.first_line - 1
          first_comment = nil

          processed_source.comments_before_line(annotation_line)
                          .reverse_each do |comment|
            if comment.location.line == annotation_line
              first_comment = comment
              annotation_line -= 1
            end
          end

          start_line_position(first_comment || node)
        end

        def start_line_position(node)
          buffer.line_range(node.loc.line).begin_pos - 1
        end

        def buffer
          processed_source.buffer
        end

        # Load expected order from `ExpectedOrder` config.
        # Define new terms in the expected order by adding new {categories}.
        def expected_order
          cop_config['ExpectedOrder']
        end

        # Setting categories hash allow you to group methods in group to match
        # in the {expected_order}.
        def categories
          cop_config['Categories']
        end
      end
    end
  end
end