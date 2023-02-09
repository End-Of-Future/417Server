--黄金拼图 九条可怜
local m=10700030
local cm=_G["c"..m]

function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2,2,cm.lcheck)
	c:EnableReviveLimit()
    --splimit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.regcon)
	e1:SetOperation(cm.regop)
	c:RegisterEffect(e1)
    --special summon
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,3))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,m)
	e3:SetTarget(cm.sptg)
	e3:SetOperation(cm.spop)
	c:RegisterEffect(e3)
    --release
    local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,4))
	e4:SetCategory(CATEGORY_RELEASE+CATEGORY_RECOVER+CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_QUICK_O)
    e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1,m+1)
    e4:SetCost(cm.recost)
	e4:SetTarget(cm.retg)
	e4:SetOperation(cm.reop)
	c:RegisterEffect(e4)
end

function cm.lcheck(g)
	return g:IsExists(Card.IsLink,1,nil,2)
end

function cm.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
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

function cm.spfilter(c,e,tp,zone)
	return c:IsLink(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,tp,zone)
end

function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(1-tp) and cm.spfilter(chkc,e,tp,zone) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cm.spfilter,tp,0,LOCATION_GRAVE,1,nil,e,tp,zone) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.spfilter,tp,0,LOCATION_GRAVE,1,1,nil,e,tp,zone)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local tc=Duel.GetFirstTarget()
	local zone=bit.band(e:GetHandler():GetLinkedZone(tp),0x1f)
	if tc:IsRelateToEffect(e) and zone~=0 then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP,zone)
	end
end

function cm.recost(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    if chk==0 then return c:IsReleasable() end
    Duel.Release(c,REASON_COST)
end

function cm.retg(e,tp,eg,ep,ev,re,r,rp,chk)
    local c=e:GetHandler()
    local g=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,0,c)
    local fg=Duel.GetMatchingGroup(aux.TRUE,tp,0x04,0,c)
    local gg=Duel.GetMatchingGroup(Card.IsReleasable,tp,0x04,0,c)
    if #fg-#gg<=1 and #gg>0 and #fg>=2 then g:Merge(gg) end
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_RELEASE,g,#g,nil,nil)
    Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,nil,tp,nil)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end

function cm.clfilter(c)
    return not c:IsLocation(LOCATION_ONFIELD)
end

function cm.reop(e,tp,eg,ep,ev,re,r,rp)
    local off=1
	local ops={}
	local opval={}
    local fg=Duel.GetFieldGroup(tp,0x04,0)
	if #fg-Duel.GetMatchingGroupCount(Card.IsReleasable,tp,0x04,0,nil)<=1 and Duel.GetMatchingGroupCount(Card.IsReleasable,tp,0x04,0,nil)>=1 and #fg>=2 then
		ops[off]=aux.Stringid(m,0)
		opval[off-1]=1
		off=off+1
	end
	if Duel.GetMatchingGroupCount(Card.IsReleasableByEffect,tp,LOCATION_MZONE,0,nil)>=1 then
		ops[off]=aux.Stringid(m,1)
		opval[off-1]=2
		off=off+1
	end
	if Duel.GetMatchingGroupCount(Card.IsReleasableByEffect,tp,LOCATION_ONFIELD,0,nil)>=1 then
		ops[off]=aux.Stringid(m,2)
		opval[off-1]=3
		off=off+1
	end
	if off==1 then return end
	local op=Duel.SelectOption(tp,table.unpack(ops))
    local tg=Group.CreateGroup()
	if opval[op]==1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
		local g=Duel.SelectMatchingCard(tp,Card.IsReleasable,tp,0x04,0,#fg-1,#fg-1,nil)
		if g:GetCount()>0 then
			Duel.HintSelection(g)
			if Duel.Release(g,REASON_RULE) then
				tg=Duel.GetOperatedGroup()
			end
		end
	elseif opval[op]==2 then
		local g=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,0x04,0,nil)
		if g:GetCount()>0 and Duel.Release(g,REASON_EFFECT) then
            tg=Duel.GetOperatedGroup()
            if #tg>0 then
                Duel.BreakEffect()
                Duel.Recover(tp,#tg*300,REASON_EFFECT)
            end
		end
	elseif opval[op]==3 then
		local g=Duel.GetMatchingGroup(Card.IsReleasableByEffect,tp,0x0c,0,nil)
		if g:GetCount()>0 and Duel.Release(g,REASON_EFFECT) then
			tg=Duel.GetOperatedGroup()
            if #tg==4 then
                Duel.BreakEffect()
                Duel.Draw(tp,1,REASON_EFFECT)
            end
		end
	end
    if #tg>0 then
        tg:KeepAlive()
        local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CANNOT_ACTIVATE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetLabelObject(tg)
		e1:SetValue(cm.activeturnlimit)
		e1:SetReset(RESET_PHASE+PHASE_END)
		Duel.RegisterEffect(e1,tp)
    end
end

function cm.activeturnlimit(e,re,tp)
	local rc=re:GetHandler()
	return e:GetLabelObject():IsContains(rc)
end