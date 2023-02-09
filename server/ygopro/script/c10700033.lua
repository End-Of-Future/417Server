--救济幻想 丈枪由纪
local m=10700033
local cm=_G["c"..m]

function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLink,2),4,8)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
    e0:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	e0:SetOperation(cm.regop)
	c:RegisterEffect(e0)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,m+1+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(cm.thcon)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end

function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMatchingGroupCount(Card.IsCode,tp,0x1ff,0x1ff,nil,10700009)==0 then
		Duel.RegisterFlagEffect(rp,107000090+Duel.GetTurnCount(),0,0,1)
	end
end

function cm.regop(e,tp,eg,ep,ev,re,r,rp)
    Duel.Hint(HINT_CARD,0,m)
    local tc={10700000,10700003,10700009,10700012,10700015}
	local i=1
	while i<=10 do
		if i<=5 then
			local tc=Duel.CreateToken(tp,tc[i])
			Duel.DisableShuffleCheck()
            Duel.SendtoDeck(tc,tp,2,REASON_EFFECT)
        else
			local tc=Duel.CreateToken(1-tp,tc[i-5])
			Duel.DisableShuffleCheck()
            Duel.SendtoDeck(tc,1-tp,2,REASON_EFFECT)
        end
        i=i+1
    end
    Duel.ShuffleDeck(tp)
    Duel.ShuffleDeck(1-tp)
    Duel.Draw(tp,1,REASON_EFFECT)
    Duel.Draw(1-tp,1,REASON_EFFECT)
end

function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end

function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return true end
	if c:GetMaterialCount()==4 then
		local g=c:GetMaterial()
		Duel.SetOperationInfo(0,CATEGORY_SUMMON,g,1,0,0)
	elseif c:GetMaterialCount()==8 then
		e:SetCategory(CATEGORY_ATKCHANGE)
	end
end

function cm.spfilter(c,e,tp)
	return c:IsLink(2) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cm.aufilter(c)
	return c:GetBaseAttack()~=0 and c:IsType(TYPE_MONSTER)
end

function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
    if #mg==4 and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(cm.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,nil,e,tp) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,cm.spfilter,tp,LOCATION_GRAVE+LOCATION_EXTRA,0,1,1,nil,e,tp)
		if #g>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
	if #mg==8 and mg:IsExists(cm.aufilter,1,nil) then
		local atk=mg:Filter(cm.aufilter,nil):GetSum(Card.GetBaseAttack)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetRange(LOCATION_MZONE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end