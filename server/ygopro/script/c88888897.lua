--广异之中闻太岁
local m=88888897
local cm=_G["c"..m]

function cm.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(m,0))
    e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DISABLE)
    e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
    e1:SetCondition(cm.condition2)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.operation)
	c:RegisterEffect(e1)
    local e3=e1:Clone()
    e3:SetCondition(cm.condition)
    e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
    c:RegisterEffect(e3)
    --remove
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,1))
    e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,m+1)
    e2:SetCost(cm.recost)
	e2:SetTarget(cm.retg)
	e2:SetOperation(cm.reop)
	c:RegisterEffect(e2)
end

function cm.condition(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_SZONE,0,nil)==0
end

function cm.condition2(e,tp,eg,ep,ev,re,r,rp)
    return Duel.GetMatchingGroupCount(Card.IsFaceup,tp,LOCATION_SZONE,0,nil)~=0
end

function cm.sptgfilter(c,e,tp)
    return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingTarget(cm.sptgfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    local g=Duel.SelectTarget(tp,cm.sptgfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
    Duel.HintSelection(g)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),nil,nil)
    Duel.SetOperationInfo(0,CATEGORY_DISABLE,nil,1,1-tp,LOCATION_SZONE)
end

function cm.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE) then
        Duel.BreakEffect()
        local e1=Effect.CreateEffect(c)
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_DISABLE)
        e1:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e1,true)
        local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_DISABLE_EFFECT)
        e2:SetValue(RESET_TURN_SET)
        e2:SetReset(RESET_EVENT+RESETS_STANDARD)
        tc:RegisterEffect(e2,true)
        if tc:IsOnField() and Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_SZONE,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
            Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
            local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,0,LOCATION_SZONE,1,1,nil)
            Duel.HintSelection(g)
            local gc=g:GetFirst()
            if gc then
                local pose=gc:GetPosition()
                tc:SetCardTarget(gc)
                if pose==POS_FACEUP then
                    local e1=Effect.CreateEffect(c)
                    e1:SetType(EFFECT_TYPE_TARGET)
                    e1:SetCode(EFFECT_DISABLE)
                    e1:SetRange(LOCATION_MZONE)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                    tc:RegisterEffect(e1)
                    local e2=e1:Clone()
                    e2:SetCode(EFFECT_DISABLE_EFFECT)
                    e2:SetValue(RESET_TURN_SET)
                    tc:RegisterEffect(e2)
                elseif pose==POS_FACEDOWN then
                    local e1=Effect.CreateEffect(c)
                    e1:SetType(EFFECT_TYPE_TARGET)
                    e1:SetCode(EFFECT_CANNOT_TRIGGER)
                    e1:SetRange(LOCATION_MZONE)
                    e1:SetReset(RESET_EVENT+RESETS_STANDARD)
                    tc:RegisterEffect(e1)
                end
            end
        end
    end
end

function cm.recost(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(),REASON_COST)
end

function cm.rettfilter(c)
    return c:IsAbleToRemove() and c:IsType(TYPE_MONSTER)
end

function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then return Duel.IsExistingMatchingCard(cm.rettfilter,tp,0,LOCATION_GRAVE,1,nil) end
    local g=Duel.GetMatchingGroup(cm.rettfilter,tp,0,LOCATION_GRAVE,nil)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,nil,nil)
end

function cm.reop(e,tp,eg,ep,ev,re,r,rp)
    local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
    local g=Duel.SelectMatchingCard(tp,cm.rettfilter,tp,0,LOCATION_GRAVE,1,1,nil)
    local tc=g:GetFirst()
    if tc then
        Duel.HintSelection(g)
        if Duel.Remove(tc,POS_FACEUP,REASON_EFFECT+REASON_TEMPORARY) then
            local e1=Effect.CreateEffect(c)
            e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
            e1:SetCode(EVENT_PHASE+PHASE_END)
            e1:SetReset(RESET_PHASE+PHASE_END)
            e1:SetLabelObject(tc)
            e1:SetCountLimit(1)
            e1:SetOperation(cm.retop)
            Duel.RegisterEffect(e1,tp)
        end
    end
end

function cm.retop(e,tp,eg,ep,ev,re,r,rp)
	Duel.SendtoGrave(e:GetLabelObject(),REASON_RETURN+REASON_TEMPORARY)
end
