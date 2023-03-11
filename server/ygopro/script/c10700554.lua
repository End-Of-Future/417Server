--辉夜大小姐想让我告白 四条真妃
local m=10700554
local cm=_G["c"..m]

function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkRace,RACE_FAIRY),2,2,cm.lcheck)
    c:EnableReviveLimit()
    --splimit
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCondition(cm.regcon)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
    --
    local e2=Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(m,0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_RECOVER+CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
    e2:SetCode(EVENT_TO_HAND)
    e2:SetProperty(EFFECT_FLAG_DELAY)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCountLimit(1,m+1)
    e2:SetCondition(cm.discon)
    e2:SetCost(cm.discost)
	e2:SetTarget(cm.distg)
	e2:SetOperation(cm.disop)
	c:RegisterEffect(e2)
end

function cm.lcheck(g,lc)
	return g:IsExists(Card.IsLinkAttribute,1,nil,ATTRIBUTE_WIND)
end

function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.opmfilter(c,tp)
    return c:IsAbleToRemove(tp,POS_FACEDOWN) and c:IsType(TYPE_MONSTER)
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetFieldGroup(tp,0x01,0)
    local rg=g:Filter(cm.opmfilter,nil,tp)
    if #g>=6 and rg:CheckSubGroup(aux.dncheck,5,5) and Duel.IsPlayerCanDraw(tp,1) and Duel.GetFlagEffect(tp,m)==0  then
        Duel.Hint(HINT_CARD,0,m)
        Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
        Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
        rg=rg:SelectSubGroup(tp,aux.dncheck,false,5,5)
        if Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT) then
            Duel.ConfirmCards(1-tp,rg)
            rg:KeepAlive()
            local e4=Effect.CreateEffect(e:GetHandler())
            e4:SetType(EFFECT_TYPE_FIELD)
            e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
            e4:SetTargetRange(1,0)
            e4:SetLabelObject(rg)
            e4:SetCode(EFFECT_CANNOT_ACTIVATE)
            e4:SetValue(cm.aclimit)
            Duel.RegisterEffect(e4,tp)
            Duel.Draw(tp,1,REASON_EFFECT)
        end
    end
    local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(cm.splimit)
	Duel.RegisterEffect(e1,tp)
end

function cm.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(m) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.aclimit(e,re,tp)
	return e:GetLabelObject():IsExists(Card.IsCode,1,nil,re:GetHandler():GetCode())
end

function cm.condfilter(c,tp)
    return c:IsType(TYPE_MONSTER) and c:IsLocation(0x02) and c:IsControler(tp) and c:IsPreviousLocation(0x01) and not c:IsPublic()
end

function cm.discon(e,tp,eg,ep,ev,re,r,rp,chk)
    return ep==tp and #eg==1 and eg:IsExists(cm.condfilter,1,nil,tp) and Duel.GetFieldGroupCount(tp,0x01,0)>6
end

function cm.discost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
    Duel.ConfirmCards(1-tp,eg)
end

function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
    local ec=eg:GetFirst()
	if chk==0 then return ec:IsAbleToDeck() and ec:GetBaseAttack()~=0 and ec:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsPlayerCanDraw(tp,1) end
    Duel.SetTargetCard(ec)
    Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,0x02)
    Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,0x02)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,ec:GetBaseAttack())
end

function cm.disop(e,tp,eg,ep,ev,re,r,rp)
    if not (Duel.GetFieldGroupCount(tp,0x01,0)>6) then return false end
    local tc=Duel.GetFirstTarget()
    local code=tc:GetCode()
    if tc:IsRelateToEffect(e) and Duel.SendtoDeck(tc,nil,2,REASON_EFFECT) and Duel.Draw(tp,1,REASON_EFFECT) then
        local oc=Duel.GetOperatedGroup():GetFirst()
        Duel.ConfirmCards(1-tp,oc)
        if oc:IsCode(code) and oc:IsType(TYPE_MONSTER) and oc:IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.GetLocationCount(tp,0x04)>0 and Duel.SpecialSummon(oc,0,tp,tp,false,false,POS_FACEUP) then
            Duel.Recover(tp,oc:GetBaseAttack(),REASON_EFFECT)
        end
        if oc:IsType(TYPE_SPELL+TYPE_TRAP) then
            Duel.Remove(oc,POS_FACEUP,REASON_EFFECT)
        end
        Duel.ShuffleHand(tp)
    end
end